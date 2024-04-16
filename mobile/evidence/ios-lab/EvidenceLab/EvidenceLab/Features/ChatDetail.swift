import ComposableArchitecture
import SwiftUI

#Preview {
    dataClient = DataClient.mock(Chat.mockList)
    
    return ChatDetailView(
        store: Store(
            initialState: ChatDetailFeature.State(chat: .lili),
            reducer: { ChatDetailFeature() }
        )
    )
}

@Reducer
struct ChatDetailFeature {
    @ObservableState
    struct State: Equatable, Hashable {
        var chat: Chat
        var inputText: String
        var messages: IdentifiedArrayOf<MessageFeature.State>
        var user: User
        
        init(chat: Chat, inputText: String = "") {
            self.chat = chat
            self.inputText = inputText
            self.messages = IdentifiedArray(
                uniqueElements: chat.messages.map { MessageFeature.State(message: $0) }
            )
            self.user = authClient.getAuthenticatedUser() ?? User()
        }
    }
    
    @CasePathable
    enum Action {
        case inputTextUpdated(String)
        case message(IdentifiedActionOf<MessageFeature>)
        case send
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .inputTextUpdated(update):
                state.inputText = update
                return .none
                
            case .message:
                return .none
                
            case .send:
                let newMessage = Message(content: state.inputText, sender: state.user)
                let newMessageState = MessageFeature.State(message: newMessage)
                state.messages.append(newMessageState)
                state.inputText = ""
                return .none
            }
        }
        .forEach(\.messages, action: \.message) {
            MessageFeature()
        }
        .onChange(of: \.messages) { oldValue, newValue in
            Reduce { state, action in
                state.chat.messages = newValue.map { $0.message }
                return .none
            }
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
            .listStyle(.plain)
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
                    set: { store.send(.inputTextUpdated($0)) }
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
        .navigationTitle(store.chat.name)
    }
}



