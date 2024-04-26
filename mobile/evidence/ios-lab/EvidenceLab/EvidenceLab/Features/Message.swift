import ComposableArchitecture
import SwiftUI

@Reducer
struct MessageFeature {
    @ObservableState
    struct State: Equatable, Codable, Identifiable {
        @ObservationStateIgnored
        @Shared var message: Message
        var user: User
        var id: MessageID { message.id }
        
        init(message: Shared<Message>) {
            self._message = message
            self.user = authClient.getAuthenticatedUser() ?? User()
        }
        
        var alignment: HorizontalAlignment {
            message.sender.id == user.id ? .trailing : .leading
        }
        
        var textAlignment: TextAlignment {
            return message.sender.id == user.id ? .trailing : .leading
        }
        
        var frameAlignment: Alignment {
            return message.sender.id == user.id ? .trailing : .leading
        }
    }
    
    enum Action {
        case onViewDidLoad
        case onPreviewDidLoad(Preview)

    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewDidLoad:
                guard
                    let url = URL(string: state.message.content),
                    url.host() != nil,
                    state.message.preview == nil else {
                    return .none
                }
                
                return .publisher {
                    URLPreviewClient.live
                        .get(url)
                        .receive(on: DispatchQueue.main)
                        .filter { $0 != nil }
                        .map { $0! }
                        .map { Preview(image: $0.image, title: $0.title) }
                        .map { .onPreviewDidLoad($0) }
                }
                
            case let .onPreviewDidLoad(preview):
                state.message.preview = preview
                return .none
            }
        }
    }
}

struct MessageView: View {
    let store: StoreOf<MessageFeature>
    
    var body: some View {
        VStack(alignment: store.alignment) {
            HStack {
                VStack(alignment: store.alignment) {
                    Text(store.message.content)
                        .frame(maxWidth: .infinity, alignment: store.frameAlignment)
                    Text(store.message.sender.name).font(.caption2)
                        .frame(maxWidth: .infinity, alignment: store.frameAlignment)
                    if store.message.isSent {
                        Label("", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                    }
                }
                .multilineTextAlignment(store.textAlignment)
            }
            if let preview = store.message.preview {
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
            store.send(.onViewDidLoad)
        }
    }
}
