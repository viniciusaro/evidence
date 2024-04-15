import CasePaths
import Foundation
import SwiftUI

#Preview {
    MessageView(
        store: Store(
            initialState: MessageFeature.State(message: .pointfree),
            reducer: MessageFeature.reducer
        )
    )
}

struct MessageFeature: Feature {
    struct State: Equatable, Hashable {
        var message: Message
        
        init(message: Message) {
            self.message = message
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
                    let url = URL(string: state.message.content),
                    url.host() != nil,
                    state.message.preview == nil else {
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
                state.message.preview = preview
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
                    Text(viewStore.message.content)
                    Spacer()
                    if viewStore.message.isSent {
                        Label("", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
                if let preview = viewStore.message.preview {
                    AsyncImage(url: preview.image) { phase in
                        if let image = phase.image {
                            image.resizable()
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
