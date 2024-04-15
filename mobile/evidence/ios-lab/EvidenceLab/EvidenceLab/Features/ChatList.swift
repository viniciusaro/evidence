import CasePaths
import Foundation
import IdentifiedCollections
import SwiftUI

#Preview {
    ChatListView(
        store: Store(
            initialState: ChatListFeature.State(),
            reducer: ChatListFeature.reducer
        )
    )
}

struct ChatListFeature: Feature {
    struct State: Equatable {
        var chats: IdentifiedArrayOf<Chat> = []
        var detail: ChatDetailFeature.State? = nil
        
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
        case chatListNavigation(ChatDetailFeature.State?)
        case chatListItemTapped(Chat)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case let .chatListItemTapped(chat):
                state.detail = ChatDetailFeature.State(chat: chat)
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
        }
    }
}
