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
        @ObservationStateIgnored 
        @Shared var chats: IdentifiedArrayOf<Chat> = []
        @Presents var detail: ChatDetailFeature.State? = nil
        @Presents var newChatSetup: NewChatSetupFeature.State? = nil
        
        init(detail: ChatDetailFeature.State? = nil) {
            self.detail = detail
            do {
                let data = try dataClient.load(.chats)
                let decoder = JSONDecoder()
                self.chats = try decoder.decode(IdentifiedArrayOf<Chat>.self, from: data)
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
        case onListItemTapped(Chat)
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
                if let chat = state.chats[id: chatUpdate.id] {
                    state.chats[id: chat.id]?.messages.append(contentsOf: chatUpdate.messages)
                    moveChatUp(&state, chat)
                } else {
                    state.chats.insert(chatUpdate, at: 0)
                }
                return .none
                
            case let .onListItemTapped(chat):
                state.detail = ChatDetailFeature.State(chat: state.$chats[chat])
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
        Reduce { state, action in
            guard case .detail(.presented(.send)) = action else {
                return .none
            }
            guard let chat = state.detail?.chat else {
                return .none
            }
            
            moveChatUp(&state, chat)
            
            return .publisher {
                stockClient.send(chat.messages.last!, chat)
                    .map { .onChatUpdateSent }
                    .receive(on: DispatchQueue.main)
            }
        }
        .onChange(of: \.chats) { _, __ in
            Reduce { state, action in
                .run { [chats = state.chats] _ in
                    let data = try JSONEncoder().encode(chats)
                    try dataClient.save(data, .chats)
                }
            }
        }
    }
    
    private func moveChatUp(_ state: inout State, _ chat: Chat) {
        NSLock().withLock {
            if let index = state.chats.index(id: chat.id) {
                state.chats.move(
                    fromOffsets: IndexSet(arrayLiteral: index),
                    toOffset: 0
                )
            }
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
                        if let content = chat.messages.last?.content {
                            Text(content).font(.caption)
                        }
                    }
                    EmptyView()
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
