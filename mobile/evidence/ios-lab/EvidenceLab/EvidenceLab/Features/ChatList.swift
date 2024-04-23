import ComposableArchitecture
import SwiftUI

#Preview {
    dataClient = DataClient.mock(Chat.mockList)
    stockClient = StockClient.mock(Chat.mockList)
    
    return ChatListView(
        store: Store(
            initialState: ChatListFeature.State(),
            reducer: { ChatListFeature() }
        )
    )
}

@Reducer
struct ChatListFeature {
    @ObservableState
    struct State: Equatable, Codable {
        var chats: IdentifiedArrayOf<ChatDetailFeature.State> = []
        @Presents var detail: ChatDetailFeature.State? = nil
        @Presents var newChatSetup: NewChatSetupFeature.State? = nil
        
        init(detail: ChatDetailFeature.State? = nil) {
            self.detail = detail
            do {
                let data = try dataClient.load(.chats)
                let decoder = JSONDecoder()
                let chats = try decoder.decode(IdentifiedArrayOf<Chat>.self, from: data)
                self.chats = chats.map { .init(chat: $0) }.identified
            } catch {
                self.chats = []
            }
        }
    }
    
    @CasePathable
    enum Action {
        case detail(PresentationAction<ChatDetailFeature.Action>)
        case newChatSetup(PresentationAction<NewChatSetupFeature.Action>)
        case onChatUpdateReceived(Chat)
        case onChatUpdateSent
        case onListItemTapped(ChatDetailFeature.State)
        case onListItemDelete(IndexSet)
        case onViewDidLoad
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer().ifLet(\.$detail, action: \.detail) {
            ChatDetailFeature()
        }
        .ifLet(\.$newChatSetup, action: \.newChatSetup) {
            NewChatSetupFeature()
        }
        Reduce { state, action in
            switch action {
            case .detail, .newChatSetup, .onChatUpdateSent:
                return .none
                
            case let .onChatUpdateReceived(chatUpdate):
                let chatState = ChatDetailFeature.State(chat: chatUpdate)
                
                if let chat = state.chats[id: chatUpdate.id] {
                    state.chats[id: chat.id]?.messages.append(contentsOf: chatState.messages)
//                    moveChatUp(&state, chat)
                } else {
                    state.chats.insert(chatState, at: 0)
                }
                return .none
                
            case let .onListItemTapped(chatState):
                state.detail = chatState
                return .none
                
            case let .onListItemDelete(indexSet):
                state.chats.remove(atOffsets: indexSet)
                return .none
            
            case .onViewDidLoad:
                return .publisher {
                    stockClient.consume()
                        .map { .onChatUpdateReceived($0) }
                        .receive(on: DispatchQueue.main)
                }
            }
        }
        .onChange(of: \.chats) { _, chats in
            Reduce { state, action in
                guard let detail = state.detail else {
                    return .none
                }
                guard let chat = chats[id: detail.id] else {
                    return .none
                }
                state.detail? = chat
                return .none
            }
        }
        Reduce { state, action in
            guard case .detail(.presented(.send)) = action else {
                return .none
            }
            guard let chatState = state.detail else {
                return .none
            }
            
            state.chats[id: chatState.id] = chatState
            let chat = chatState.toChat()
//            moveChatUp(&state, chat)
            
            return .publisher {
                stockClient.send(chat.messages.last!, chat)
                    .map { .onChatUpdateSent }
                    .receive(on: DispatchQueue.main)
            }
        }
        .onChange(of: \.chats) { _, chats in
//            Reduce { state, action in
//                .run { [chats = chats] _ in
//                    let data = try JSONEncoder().encode(chats)
//                    try dataClient.save(data, .chats)
//                }
//            }
        }
    }
    
    private func moveChatUp(_ state: inout State, _ chat: Chat) {
        if let index = state.chats.index(id: chat.id) {
            state.chats.move(
                fromOffsets: IndexSet(arrayLiteral: index),
                toOffset: 0
            )
        }
    }
}

struct ChatListView: View {
    let store: StoreOf<ChatListFeature>
    
    var body: some View {
        List {
            ForEach(store.chats) { chat in
                Button(action: {
                    store.send(.onListItemTapped(chat))
                }, label: {
                    VStack(alignment: .leading) {
                        Text(chat.name)
                        if let content = chat.messages.last?.message.content {
                            Text(content).font(.caption)
                        }
                    }
                })
            }
            .onDelete { indexSet in
                store.send(.onListItemDelete(indexSet))
            }
        }
        .animation(.bouncy, value: store.chats)
        .listStyle(.plain)
        .onViewDidLoad {
            store.send(.onViewDidLoad)
        }
    }
}
