import ComposableArchitecture
import Models
import SwiftUI

@Reducer
public struct ChatDetailFeature {
    @ObservableState 
    public struct State: Equatable {
        @Shared var chat: Chat
        var inputText: String = ""
        var messages: IdentifiedArrayOf<MessageFeature.State>
        
        init(chat: Shared<Chat>) {
            self._chat = chat
            self.messages = IdentifiedArray(uniqueElements: chat.wrappedValue.messages.map {
                MessageFeature.State(message: chat.messages[id: $0.id]!)
            })
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case message(IdentifiedActionOf<MessageFeature>)
        case onMessageSentConfirmation(Message)
        case send
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .message:
                return .none
                
            case .onMessageSentConfirmation:
                return .none
                
            case .send:
                let user = authClient.getAuthenticatedUser() ?? User()
                let newMessage = Message(content: state.inputText, sender: user)
                state.chat.messages.append(newMessage)
                state.inputText = ""

                let sharedMessage = state.$chat.messages[id: newMessage.id]!
                let newMessageState = MessageFeature.State(message: sharedMessage)
                state.messages.append(newMessageState)
                
                let chatUpdate = ChatUpdate.from(
                    chat: state.chat,
                    message: newMessage
                )
                
                return .publisher {
                    stockClient.send(chatUpdate)
                        .receive(on: DispatchQueue.main)
                        .map { .onMessageSentConfirmation(newMessage) }
                }
            }
        }
        .forEach(\.messages, action: \.message) {
            MessageFeature()
        }
        BindingReducer()
    }
}

struct ChatDetailView: View {
    @Bindable var store: StoreOf<ChatDetailFeature>
    
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
