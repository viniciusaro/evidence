import Combine
import ComposableArchitecture
import Dependencies
import Leaf
import PhotoClient
import SwiftUI

#Preview {
    LeafThemeView {
        NavigationStack {
            PhotosView(store: Store(initialState: .init()) {
                PhotosFeature()
            })
        }
    }
}

@Reducer
public struct PhotosFeature {
    @Dependency(\.photoClient) var photoClient
    
    @ObservableState
    public struct State: Equatable {
        var assets: [AssetImage]
        
        public init() {
            self.assets = []
        }
    }
    
    @CasePathable
    public enum Action {
        case onViewDidLoad
        case onAssetsLoaded([Asset])
        case onImagesLoaded([AssetImage])
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onImagesLoaded(let images):
                state.assets = images
                return .none
                
            case .onAssetsLoaded(let assets):
                let asyncImages = assets.map {
                    photoClient.data($0)
                        .receive(on: DispatchQueue.main)
                }

                return .publisher {
                    Publishers.MergeMany(asyncImages)
                        .collect(asyncImages.count)
                        .receive(on: DispatchQueue.main)
                        .map { .onImagesLoaded($0) }
                }
                
            case .onViewDidLoad:
                return .publisher {
                    photoClient.assets()
                        .receive(on: DispatchQueue.main)
                        .map { .onAssetsLoaded($0) }
                }
            }
        }
    }
}

struct PhotosView: View {
    let store: StoreOf<PhotosFeature>
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4, content: {
                ForEach(store.assets) { asset in
                    Image(uiImage: asset.image)
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.size.width / 3,
                            height: UIScreen.main.bounds.size.width / 3
                        )
                        .aspectRatio(contentMode: .fill)
                }
            })
        }
        .navigationTitle("Fotos")
        .navigationBarTitleDisplayMode(.inline)
        .onViewDidLoad {
            store.send(.onViewDidLoad)
        }
    }
}
