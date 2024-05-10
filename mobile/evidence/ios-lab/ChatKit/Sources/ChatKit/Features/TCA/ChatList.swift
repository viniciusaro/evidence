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

public enum PluginAction {
    case onMessageSent(ChatUpdate)
    case onMessageReceived(ChatUpdate)
}

@Reducer
struct OpenAIPlugin {
    @Dependency(\.openAIClient) var openAIClient
    
    var body: some Reducer<Void, PluginAction> {
        Reduce { state, action in
            switch action {
            case let .onMessageReceived(chatUpdate):
                if chatUpdate.message.sender == .cris {
                    return .publisher {
                        openAIClient.send(chatUpdate.message.content)
                            .receive(on: DispatchQueue.main)
                            .map {
                                var update = chatUpdate
                                update.message = Message(content: $0, sender: .openAI)
                                return .onMessageReceived(update)
                            }
                    }
                }
                return .none
            default:
                return .none
            }
        }
    }
}

struct PluginReducer<State, Action>: Reducer {
    typealias State = State
    typealias Action = Action
    let fromAction: (Action) -> PluginAction?
    let toAction: (PluginAction) -> Action
    let child: () -> any Reducer<Void, PluginAction>
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            if let childAction = fromAction(action) {
                var fakeState: Void = ()
                let effect = child().reduce(into: &fakeState, action: childAction)
                let parentEffect = effect.map(toAction)
                return parentEffect
            }
            return .none
        }
    }
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
        case onNewMessageReceived(ChatUpdate)
        case onViewDidLoad
        case onChatMoveUpRequested(Chat)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .detail(.presented(.send)):
                guard let chat = state.detail?.chat else {
                    return .none
                }
                return .send(.onChatMoveUpRequested(chat))
                
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
                
            case let .onNewMessageReceived(chatUpdate):
                guard let existingChat = state.chats[id: chatUpdate.chatId] else {
                    state.chats.insert(chatUpdate.toChat(), at: 0)
                    return .none
                }
                guard let shared = state.$chats[id: existingChat.id] else {
                    return .none
                }
                shared.wrappedValue.messages.append(chatUpdate.message)
                return .send(.onChatMoveUpRequested(existingChat))
                
            case .onViewDidLoad:
                return .publisher {
                    stockClient.consume()
                        .receive(on: DispatchQueue.main)
                        .map { .onNewMessageReceived($0) }
                }
            }
        }
        PluginReducer(fromAction: { action in
            if case let .onNewMessageReceived(chatUpdate) = action {
                return .onMessageReceived(chatUpdate)
            }
            return nil
        }, toAction: { pluginAction in
            switch pluginAction {
            case .onMessageSent(_):
                return .onViewDidLoad
            case let .onMessageReceived(chatUpdate):
                return .onNewMessageReceived(chatUpdate)
            }
        }, child: {
            OpenAIPlugin()
        })
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
