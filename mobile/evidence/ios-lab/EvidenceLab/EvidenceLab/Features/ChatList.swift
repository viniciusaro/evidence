import ComposableArchitecture
import Foundation
import IdentifiedCollections
import SwiftUI

//#Preview {
//    ChatListView(
//        store: Store(
//            initialState: ChatListFeature.State(),
//            reducer: ChatListFeature.reducer
//        )
//    )
//}

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
        case onListItemTapped(Chat)
        case onListItemDelete(IndexSet)
    }
    
    var body: some ReducerOf<Self> {
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
                
            case let .onListItemTapped(chat):
                state.detail = ChatDetailFeature.State(chat: chat)
                return .none
                
            case let .onListItemDelete(indexSet):
                state.chats.remove(atOffsets: indexSet)
                return .none
            }
        }
        .ifLet(\.$detail, action: \.detail) {
            ChatDetailFeature()
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
                        Text(chat.messages.last?.content ?? "").font(.caption)
                    }
                })
            }
            .onDelete { indexSet in
                store.send(.onListItemDelete(indexSet))
            }
        }
        .listStyle(.plain)
    }
}
