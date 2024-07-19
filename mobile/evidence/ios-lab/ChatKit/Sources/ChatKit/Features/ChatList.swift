import AuthClient
import ComposableArchitecture
import Models
import StockClient
import DataClient
import SwiftUI

#Preview {
    ChatListView(store: Store(initialState: .init()) {
        ChatListFeature()
    })
}

@Reducer
public struct ChatListFeature {
    @Dependency(\.authClient) static var authClient
    @Dependency(\.stockClient) var stockClient
    
    @ObservableState
    public struct State: Equatable {
        @Shared var chats: IdentifiedArrayOf<Chat>
        @Presents var detail: ChatDetailFeature.State? = nil
        @Presents var newChatSetup: NewChatSetupFeature.State? = nil
        
        init() {
            let user = authClient.getAuthenticatedUser() ?? User()
            self._chats = Shared(
                wrappedValue: IdentifiedArrayOf<Chat>(),
                .fileStorage(.chats(prefix: user.id))
            )
        }
    }

    @CasePathable
    public enum Action {
        case beforeViewUnload
        case detail(PresentationAction<ChatDetailFeature.Action>)
        case newChatSetup(PresentationAction<NewChatSetupFeature.Action>)
        case onListItemDelete(IndexSet)
        case onListItemTapped(Chat)
        case onViewDidLoad
        case onChatMoveUpRequested(ChatID)
        case plugin(PluginAction)
    }
    
    enum CancelIDs {
        case consume
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .beforeViewUnload:
                return .cancel(id: CancelIDs.consume)
                
            case .detail(.presented(.send)):
                guard let detail = state.detail else {
                    return .none
                }
                if detail.inputText.isEmpty {
                    return .none
                }
                
                let message = Message(content: detail.inputText, sender: detail.user)
                detail.$chat.wrappedValue.messages.append(message)
                let chatUpdate = ChatUpdate.from(chat: detail.chat, message: message)

                return .send(.plugin(.send(chatUpdate)))
            
            case .detail:
                return .none
            
            case let .newChatSetup(.presented(.delegate(.onNewChatSetup(chat)))):
                state.newChatSetup = nil
                state.chats.insert(chat, at: 0)
                guard let shared = Shared(state.$chats[id: chat.id]) else {
                    return .none
                }
                state.newChatSetup = nil
                state.detail = ChatDetailFeature.State(chat: shared)
                return .none
            case .newChatSetup:
                return .none
                
            case let .onListItemDelete(offsets):
                state.chats.remove(atOffsets: offsets)
                return .none
                
            case let .onListItemTapped(chat):
                guard let shared = Shared(state.$chats[id: chat.id]) else {
                    return .none
                }
                state.detail = ChatDetailFeature.State(chat: shared)
                return .none

            case let .onChatMoveUpRequested(chatID):
                guard let index = state.chats.firstIndex(where: { $0.id == chatID }) else {
                    return .none
                }
                state.chats.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
                return .none
                
            case let .plugin(.onMessageReceived(chatUpdate)):
                guard let existingChat = state.chats[id: chatUpdate.chatId] else {
                    state.chats.insert(chatUpdate.toChat(), at: 0)
                    return .none
                }
                guard let shared = Shared(state.$chats[id: existingChat.id]) else {
                    return .none
                }
                
                shared.wrappedValue.participants = chatUpdate.participants
                shared.wrappedValue.plugins = chatUpdate.plugins
                
                if let existingMessage = Shared(shared.messages[id: chatUpdate.message.id]) {
                    shared.wrappedValue.messages[id: existingMessage.id] = chatUpdate.message
                } else {
                    shared.wrappedValue.messages.append(chatUpdate.message)
                }
                return .send(.onChatMoveUpRequested(existingChat.id))
                
            case .plugin(.onMessageSent):
                return .none
                
            case let .plugin(.send(chatUpdate)):
                return .concatenate(
                    .run { @MainActor send in
                        await stockClient.send(chatUpdate)
                        send(.onChatMoveUpRequested(chatUpdate.chatId))
                    },
                    .send(.plugin(.onMessageSent(chatUpdate)))
                )
            case .onViewDidLoad:
                return .publisher {
                    stockClient.consume()
                        .receive(on: DispatchQueue.main)
                        .map { .plugin(.onMessageReceived($0)) }
                }
                .cancellable(id: CancelIDs.consume)
            }
        }
        PluginsMapperReducer(\.chats, action: \.plugin) {
            PluginMapper()
        }
        .ifLet(\.$detail, action: \.detail) {
            ChatDetailFeature()
        }
        .ifLet(\.$newChatSetup, action: \.newChatSetup) {
            NewChatSetupFeature()
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
                            Text(content)
                                .font(.caption)
                                .lineLimit(1)
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
