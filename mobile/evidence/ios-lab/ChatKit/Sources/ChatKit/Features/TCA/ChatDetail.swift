import AuthClient
import ComposableArchitecture
import Models
import StockClient
import SwiftUI

@Reducer
public struct ChatDetailFeature {
    @Dependency(\.authClient) static var authClient
    @Dependency(\.stockClient) var stockClient
    @Dependency(\.previewClient) var previewClient
    
    @ObservableState
    public struct State: Equatable {
        @Shared var chat: Chat
        var user: User
        var inputText: String = ""
        
        init(chat: Shared<Chat>) {
            self._chat = chat
            self.user = authClient.getAuthenticatedUser() ?? User()
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onMessageSentConfirmation(Message)
        case onMessageViewDidLoad(Message)
        case onMessagePreviewDidLoad(Message, Models.Preview)
        case send
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .onMessageViewDidLoad(message):
                guard
                    let url = URL(string: message.content),
                    url.host() != nil,
                    message.preview == nil else {
                    return .none
                }
                
                return .publisher {
                    previewClient.get(url)
                        .receive(on: DispatchQueue.main)
                        .filter { $0 != nil }
                        .map { $0! }
                        .map { Preview(image: $0.image, title: $0.title) }
                        .map { .onMessagePreviewDidLoad(message, $0) }
                }
                
            case let .onMessagePreviewDidLoad(message, preview):
                state.chat.messages[id: message.id]?.preview = preview
                return .none
                
            case .onMessageSentConfirmation:
                return .none
                
            case .send:
                let message = Message(content: state.inputText, sender: state.user)
                state.chat.messages.append(message)
                state.inputText = ""

                let chatUpdate = ChatUpdate.from(
                    chat: state.chat,
                    message: message
                )
                
                return .publisher {
                    stockClient.send(chatUpdate)
                        .receive(on: DispatchQueue.main)
                        .map { .onMessageSentConfirmation(message) }
                }
            }
        }
        BindingReducer()
    }
}

struct ChatDetailView: View {
    @Bindable var store: StoreOf<ChatDetailFeature>
    
    var body: some View {
        VStack {
            List {
                ForEach($store.chat.messages) { $message in
                    MessageView(user: store.user, message: $message)
                        .onViewDidLoad {
                            store.send(.onMessageViewDidLoad(message))
                        }
                }
            }
            HStack(spacing: 12) {
                Button(action: {
                    
                }, label: {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .foregroundStyle(.primary)
                })
                TextField("", text: $store.inputText)
                .frame(height: 36)
                .padding([.leading, .trailing], 8)
                .background(RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 43/255, green: 43/255, blue: 43/255))
                )
                Button(action: {
                    store.send(.send)
                }, label: {
                    Label("", systemImage: "arrow.forward.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .foregroundStyle(.white, .primary)
                })
            }
            .padding(10)
            .background(Color(red: 20/255, green: 20/255, blue: 20/255))
        }
        .listStyle(.plain)
        .navigationTitle(store.chat.name)
    }
}
