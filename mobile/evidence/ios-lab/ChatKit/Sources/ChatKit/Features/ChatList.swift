import ComposableArchitecture
import SwiftUI

@Reducer
public struct ChatListFeature {
    @ObservableState
    public struct State: Equatable {
        @ObservationStateIgnored
        @Shared var chats: IdentifiedArrayOf<Chat>
        @Presents var detail: ChatDetailFeature.State? = nil
        @Presents var newChatSetup: NewChatSetupFeature.State? = nil
        
        init() {
            do {
                self.chats = try JSONDecoder().decode(
                    IdentifiedArrayOf<Chat>.self,
                    from: dataClient.load(.chats)
                )
            } catch {
                self.chats = []
            }
        }
    }

    public enum Action {
        case detail(PresentationAction<ChatDetailFeature.Action>)
        case newChatSetup(PresentationAction<NewChatSetupFeature.Action>)
        case onListItemDelete(IndexSet)
        case onListItemTapped(Chat)
        case onNewMessageReceived(Chat, Message)
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
                
            case let .onNewMessageReceived(chat, message):
                guard let existingChat = state.chats[id: chat.id] else {
                    state.chats.insert(chat, at: 0)
                    return .none
                }
                guard var shared = state.$chats[id: existingChat.id] else {
                    return .none
                }
                shared.wrappedValue.messages.append(message)
                
                if
                    let detail = state.detail,
                    detail.chat.id == chat.id,
                    let sharedMessage = shared.messages[id: message.id]
                {
                    state.detail?.messages.append(MessageFeature.State(message: sharedMessage))
                }
                
                return .send(.onChatMoveUpRequested(existingChat))
                
            case .onViewDidLoad:
                return .publisher {
                    stockClient.consume()
                        .receive(on: DispatchQueue.main)
                        .map { .onNewMessageReceived($0, $0.messages.first!) }
                }
            }
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
