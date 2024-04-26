import ComposableArchitecture
import SwiftUI

@Reducer
public struct ChatDetailFeature {
    @ObservableState
    public struct State: Equatable {
        @Shared var chat: Chat
        var user: User
        var inputText: String = ""
        var messages: IdentifiedArrayOf<MessageFeature.State>
        
        init(chat: Shared<Chat>) {
            self._chat = chat
            self.user = authClient.getAuthenticatedUser() ?? User()
            self.messages = IdentifiedArray(uniqueElements: chat.wrappedValue.messages.map {
                MessageFeature.State(message: chat.messages[id: $0.id]!)
            })
        }
        
        func alignment(_ message: Message) -> HorizontalAlignment {
            message.sender.id == user.id ? .trailing : .leading
        }
        
        func textAlignment(_ message: Message) -> TextAlignment {
            return message.sender.id == user.id ? .trailing : .leading
        }
        
        func frameAlignment(_ message: Message) -> Alignment {
            return message.sender.id == user.id ? .trailing : .leading
        }
    }
    
    public enum Action {
        case message(IdentifiedActionOf<MessageFeature>)
        case onInputTextUpdated(String)
        case onMessageSentConfirmation(Message)
        case send
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .message:
                return .none
                
            case let .onInputTextUpdated(updatedText):
                state.inputText = updatedText
                return .none
            
            case .onMessageSentConfirmation:
                return .none
                
            case .send:
                let newMessage = Message(content: state.inputText, sender: state.user)
                state.chat.messages.append(newMessage)
                state.inputText = ""
                return .publisher { [chat = state.chat] in
                    stockClient.send(newMessage, chat)
                        .receive(on: DispatchQueue.main)
                        .map { .onMessageSentConfirmation(newMessage) }
                }
            }
        }
        .onChange(of: \.chat.messages, { oldValue, messages in
            Reduce { state, action in
                state.messages = IdentifiedArray(uniqueElements: messages.map {
                    MessageFeature.State(message: state.$chat.messages[id: $0.id]!)
                })
                return .none
            }
        })
        .forEach(\.messages, action: \.message) {
            MessageFeature()
        }
    }
}

struct ChatDetailView: View {
    let store: StoreOf<ChatDetailFeature>
    
    var body: some View {
        VStack {
            List {
                ForEach(store.scope(state: \.messages, action: \.message)) { store in
                    MessageView(store: store)
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
                TextField("", text: Binding(
                    get: { store.inputText },
                    set: { store.send(.onInputTextUpdated($0)) }
                ))
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
