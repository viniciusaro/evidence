import ComposableArchitecture
import SwiftUI

#Preview {
    NewChatSetupView(
        store: Store(
            initialState: NewChatSetupFeature.State(chat: .lili),
            reducer: { NewChatSetupFeature() }
        )
    )
}

@Reducer
struct NewChatSetupFeature {
    @ObservableState
    struct State: Equatable {
        var chat: Chat
        var users: [User] = [.vini, .lili, .cris]
    }
    @CasePathable
    enum Action {
        case onUserSelected(User)
    }
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

struct NewChatSetupView: View {
    let store: StoreOf<NewChatSetupFeature>
    
    var body: some View {
        List {
            ForEach(store.users) { user in
                Button {
                    store.send(.onUserSelected(user))
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name)
                        Text(user.id).font(.caption2)
                    }
                }

            }
        }
        .listStyle(.plain)
    }
}
