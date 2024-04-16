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
    struct State: Equatable {
        var chats: IdentifiedArrayOf<Chat> = []
        @Presents var detail: ChatDetailFeature.State? = nil
        
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
        case onChatUpdate(Chat)
        case onChatUpdateSent
        case onListItemTapped(Chat)
        case onListItemDelete(IndexSet)
        case onViewDidLoad
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer().ifLet(\.$detail, action: \.detail) {
            ChatDetailFeature()
        }
        Reduce { state, action in
            switch action {
            case .detail(.dismiss):
                defer {
                    state.detail = nil
                }
                guard let chatDetail = state.detail else {
                    return .none
                }
                state.chats[id: chatDetail.chat.id] = chatDetail.chat
                return .none

            case .detail:
                return .none
                
            case .onChatUpdateSent:
                return .none
                
            case let .onChatUpdate(chatUpdate):
                if let localChat = state.chats[id: chatUpdate.id] {
                    state.chats[id: localChat.id]?.messages.append(contentsOf: chatUpdate.messages)
                } else {
                    state.chats.insert(chatUpdate, at: 0)
                }
                if let detail = state.detail, detail.chat.id == chatUpdate.id {
                    let actual = detail.chat.messages
                    let update = chatUpdate.messages
                    let existing = actual.intersection(update)
                    let new = update.subtracting(existing)
                    
                    new.forEach {
                        state.detail?.chat.messages.append($0)
                        state.detail?.messages.append(MessageFeature.State(message: $0))
                    }
                }
                
                return .none
                
            case let .onListItemTapped(chat):
                state.detail = ChatDetailFeature.State(chat: chat)
                return .none
                
            case let .onListItemDelete(indexSet):
                state.chats.remove(atOffsets: indexSet)
                return .none
            
            case .onViewDidLoad:
                return .publisher {
                    stockClient.consume()
                        .map { .onChatUpdate($0) }
                }
            }
        }
        Reduce { state, action in
            guard case .detail(.presented(.send)) = action else {
                return .none
            }
            
            let chat = state.detail!.chat
            let message = chat.messages.last!
            
            return .publisher {
                stockClient.send(message, chat)
                    .map { .onChatUpdateSent }
                    .receive(on: DispatchQueue.main)
            }
        }
        Reduce { state, action in
            var chats = state.chats
            let detailState = state.detail
            
            if let detailState = detailState {
                chats[id: detailState.chat.id] = detailState.chat
            }
            
            return .run { [chats = chats] _ in
                let data = try JSONEncoder().encode(chats)
                try dataClient.save(data, .chats)
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
                })
            }
            .onDelete { indexSet in
                store.send(.onListItemDelete(indexSet))
            }
        }
        .listStyle(.plain)
        .onViewDidLoad {
            store.send(.onViewDidLoad)
        }
    }
}
