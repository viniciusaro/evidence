import CasePaths
import Foundation
import SwiftUI

struct ChatListFeature: Feature {
    struct State: Equatable {
        var chats: [ChatDetailFeature.State] = []
        var detail: ChatDetailFeature.State? = nil
        
        init(chats: [Chat] = []) {
            self.chats = chats.map { ChatDetailFeature.State(chat:$0) }
        }
    }
    
    @CasePathable
    enum Action {
        case chatListLoad
        case chatListLoaded([Chat])
        case chatListNavigation(ChatDetailFeature.State?)
        case chatListItemTapped(ChatDetailFeature.State)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .chatListLoad:
                return .publisher(
                    chatClient.getAll()
                        .map { .chatListLoaded($0) }
                )
                
            case let .chatListLoaded(chats):
                state.chats = chats.map { ChatDetailFeature.State(chat:$0) }
                return .none
                
            case let .chatListItemTapped(chat):
                state.detail = chat
                return .none
                
            case let .chatListNavigation(chat):
                state.detail = chat
                return .none
            }
        }
    )
}

struct ChatListView: View {
    let store: Store<ChatListFeature.State, ChatListFeature.Action>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            List {
                ForEach(viewStore.chats) { chat in
                    Button(action: {
                        viewStore.send(.chatListItemTapped(chat))
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(chat.name)
                            Text(chat.messages.last?.content ?? "").font(.caption)
                        }
                    })
                }
            }
            .listStyle(.plain)
            .onViewDidLoad {
                viewStore.send(.chatListLoad)
            }
        }
    }
}
