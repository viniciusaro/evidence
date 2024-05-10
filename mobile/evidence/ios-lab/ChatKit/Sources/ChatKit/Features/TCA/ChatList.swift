import ComposableArchitecture
import Models
import OpenAIClient
import StockClient
import SwiftUI

#Preview {
    ChatListView(store: Store(initialState: .init()) {
        ChatListFeature()
    })
}

@Reducer
public struct ChatListFeature {
    @Dependency(\.stockClient) var stockClient
    @Dependency(\.openAIClient) var openAIClient
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.fileStorage(.chats)) var chats: IdentifiedArrayOf<Chat> = []
        @Presents var detail: ChatDetailFeature.State? = nil
        @Presents var newChatSetup: NewChatSetupFeature.State? = nil
    }

    @CasePathable
    public enum Action {
        case detail(PresentationAction<ChatDetailFeature.Action>)
        case newChatSetup(PresentationAction<NewChatSetupFeature.Action>)
        case onListItemDelete(IndexSet)
        case onListItemTapped(Chat)
        case onViewDidLoad
        case onChatMoveUpRequested(Chat)
        case plugin(PluginAction)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .detail(.presented(.send)):
                guard let detail = state.detail else {
                    return .none
                }
                
                let message = Message(content: detail.inputText, sender: detail.user)
                detail.chat.messages.append(message)
                let chatUpdate = ChatUpdate.from(chat: detail.chat, message: message)
                
                return .merge(
                    .publisher {
                        stockClient.send(chatUpdate)
                            .receive(on: DispatchQueue.main)
                            .map { .onChatMoveUpRequested(detail.chat) }
                    },
                    .send(.plugin(.onMessageSent(chatUpdate)))
                )
            
            case .detail:
                return .none
            
            case let .newChatSetup(.presented(.delegate(.onNewChatSetup(chat)))):
                state.newChatSetup = nil
                state.chats.insert(chat, at: 0)
                guard let shared = state.$chats[id: chat.id] else {
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
                guard let shared = state.$chats[id: chat.id] else {
                    return .none
                }
                state.detail = ChatDetailFeature.State(chat: shared)
                return .none
                
            case let .onChatMoveUpRequested(chat):
                guard let index = state.chats.firstIndex(where: { $0.id == chat.id }) else {
                    return .none
                }
                state.chats.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
                return .none
                
            case let .plugin(.onMessageReceived(chatUpdate)):
                guard let existingChat = state.chats[id: chatUpdate.chatId] else {
                    state.chats.insert(chatUpdate.toChat(), at: 0)
                    return .none
                }
                guard let shared = state.$chats[id: existingChat.id] else {
                    return .none
                }
                if let existingMessage = shared.messages[id: chatUpdate.message.id] {
                    shared.wrappedValue.messages[id: existingMessage.id] = chatUpdate.message
                } else {
                    shared.wrappedValue.messages.append(chatUpdate.message)
                }
                return .send(.onChatMoveUpRequested(existingChat))
                
            case .plugin(.onMessageSent):
                return .none
                
            case .onViewDidLoad:
                return .publisher {
                    stockClient.consume()
                        .receive(on: DispatchQueue.main)
                        .map { .plugin(.onMessageReceived($0)) }
                }
            }
        }
        PluginReducer(action: \.plugin) {
            PingPlugin()
        }
        PluginReducer(action: \.plugin) {
            OpenAIPlugin()
        }
        PluginReducer(action: \.plugin) {
            AutoCorrectPlugin()
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
