import CasePaths
import Foundation
import SwiftUI

struct MessageFeature: Feature {
    struct State: Equatable, Identifiable, Hashable {
        let id: MessageID
        var content: String
        var preview: Preview?
        var isSent: Bool
        
        init(message: Message, isSent: Bool = true) {
            self.id = message.id
            self.content = message.content
            self.preview = nil
            self.isSent = isSent
        }
    }
    
    @CasePathable
    enum Action {
        case messageViewLoad
        case messagePreviewLoaded(Preview)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .messageViewLoad:
                guard
                    let url = URL(string: state.content),
                    url.host() != nil,
                    state.preview == nil else {
                    return .none
                }
                
                return .publisher(
                    URLPreviewClient.live
                        .get(url)
                        .receive(on: DispatchQueue.main)
                        .filter { $0 != nil }
                        .map { $0! }
                        .map { Preview(image: $0.image, title: $0.title) }
                        .map { .messagePreviewLoaded($0) }
                    )
                
            case let .messagePreviewLoaded(preview):
                state.preview = preview
                return .none
            }
        }
    )
}

struct MessageView: View {
    let store: Store<MessageFeature.State, MessageFeature.Action>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Text(viewStore.content)
                    Spacer()
                    if viewStore.isSent {
                        Label("", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
                if let preview = viewStore.preview {
                    AsyncImage(url: preview.image) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .frame(height: 100)
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                        } else {
                            VStack {}
                        }
                    }
                }
            }
            .onViewDidLoad {
                viewStore.send(.messageViewLoad)
            }
        }
    }
}
