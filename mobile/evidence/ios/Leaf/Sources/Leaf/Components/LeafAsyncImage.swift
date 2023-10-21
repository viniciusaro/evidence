import Combine
import Dependencies
import SwiftUI

enum LeafAsyncImageStatus {
    case loading
    case loaded(Image)
    case error(Error)
}

class LeafAsyncImageModel: ObservableObject {
    @Published 
    private(set) var status: LeafAsyncImageStatus = .loading
    
    @Dependency(\.leafAsyncImageClient)
    private var imageClient: LeafAsyncImageClient
    private var imageCancellable: AnyCancellable?
    
    init(url: URL) {
        self.imageCancellable = self.imageClient.load(url).sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    self.status = .error(error)
                }
            },
            receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.status = .loaded(data)
            }
        )
    }
}

struct LeafAsyncImage: View {
    @ObservedObject 
    private var model: LeafAsyncImageModel
    private let viewBuilder: (LeafAsyncImageStatus) -> any View
    
    init(url: URL, @ViewBuilder viewBuilder: @escaping (LeafAsyncImageStatus) -> any View) {
        self.model = LeafAsyncImageModel(url: url)
        self.viewBuilder = viewBuilder
    }
    
    var body: some View {
        AnyView(viewBuilder(model.status))
    }
}

#Preview {
    LeafAsyncImage(url: URL.documentsDirectory) { status in
        switch status {
        case .loading: ProgressView()
        case .loaded(let image): image
        case .error(_): Image(systemName: "checkmark.circle")
        }
    }
}
