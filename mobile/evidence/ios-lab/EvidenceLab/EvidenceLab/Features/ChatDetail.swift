import ComposableArchitecture
import OrderedCollections
import SwiftUI

#Preview {
    dataClient = DataClient.mock(Chat.mockList)
    stockClient = StockClient.mock(Chat.mockList, interval: 1)
    authClient = AuthClient.authenticated()
    
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
    struct State: Equatable, Hashable, Codable {
        var chat: Chat {
            didSet {
                syncMessageStates()
            }
        }
        var user: User
        var inputText: String
        fileprivate var messages: IdentifiedArrayOf<MessageFeature.State>
        
        var title: String {
            let participants = chat.participants.reduce("", { $0 + String($1.name.first!) })
            return "\(chat.name) \(participants)"
        }
        
        mutating func syncMessageStates() {
            let updatedMessages = chat.messages
            let currentMessages = OrderedSet(messages.elements.map { $0.message })
            let existing = updatedMessages.intersection(currentMessages)
            let new = updatedMessages.subtracting(existing)
            
            new.forEach {
                messages.append(MessageFeature.State(message: $0))
            }
        }
        
        init(chat: Chat, inputText: String = "") {
            self.chat = chat
            self.user = authClient.getAuthenticatedUser() ?? User()
            self.inputText = inputText
            self.messages = chat.messages.map { MessageFeature.State(message: $0) }.identified
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
                state.chat.messages.append(newMessage)
                state.inputText = ""
                return .none
            }
        }
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
        .listStyle(.plain)
        .navigationTitle(store.title)
    }
}

extension Array where Element: Identifiable {
    var identified: IdentifiedArrayOf<Self.Element> {
        IdentifiedArray(uniqueElements: self)
    }
}

