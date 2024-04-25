import ComposableArchitecture
import SwiftUI

@Reducer
struct ChatDetailFeature {
    @ObservableState
    struct State: Equatable, Codable {
        @ObservationStateIgnored
        @Shared var chat: Chat
        var user: User
        var inputText: String = ""
        
        init(chat: Shared<Chat>) {
            self._chat = chat
            self.user = authClient.getAuthenticatedUser() ?? User()
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
    enum Action {
        case onInputTextUpdated(String)
        case onMessageSentConfirmation(Message)
        case send
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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
    }
}

struct ChatDetailView: View {
    let store: StoreOf<ChatDetailFeature>
    
    var body: some View {
        VStack {
            List {
                ForEach(store.chat.messages) { message in
                    VStack(alignment: store.state.alignment(message)) {
                        Text(message.content)
                            .frame(maxWidth: .infinity, alignment: store.state.frameAlignment(message))
                        Text(message.sender.name).font(.caption2)
                            .frame(maxWidth: .infinity, alignment: store.state.frameAlignment(message))
                    }
                    .multilineTextAlignment(store.state.textAlignment(message))
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
