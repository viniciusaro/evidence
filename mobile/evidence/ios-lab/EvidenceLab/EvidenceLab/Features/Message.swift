import ComposableArchitecture
import SwiftUI

#Preview {
    dataClient = DataClient.mock(Chat.mockList)
    
    return MessageView(
        store: Store(
            initialState: MessageFeature.State(message: .pointfree),
            reducer: { MessageFeature() }
        )
    )
}

@Reducer
struct MessageFeature {
    @ObservableState
    struct State: Identifiable, Equatable, Hashable {
        var id: MessageID { message.id }
        var message: Message
        
        init(message: Message) {
            self.message = message
        }
    }
    
    enum Action {
        case viewDidLoad
        case previewDidLoad(Preview)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewDidLoad:
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
                        .map { .previewDidLoad($0) }
                }
                
            case let .previewDidLoad(preview):
                state.message.preview = preview
                return .none
            }
        }
    }
}

struct MessageView: View {
    let store: StoreOf<MessageFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(store.message.content)
                Spacer()
                if store.message.isSent {
                    Label("", systemImage: "checkmark")
                        .labelStyle(.iconOnly)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
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
            store.send(.viewDidLoad)
        }
    }
}
