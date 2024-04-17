import ComposableArchitecture
import SwiftUI

#Preview {
    NewChatSetupView(
        store: Store(
            initialState: NewChatSetupFeature.State(),
            reducer: { NewChatSetupFeature() }
        )
    )
}

@Reducer
struct NewChatSetupFeature {
    @ObservableState
    struct State: Equatable, Codable {
        var chat: Chat
        var users: [User]
        var alertIsPresented: Bool
        var currentUser: User
        
        var alertInputText: String {
            chat.name
        }
        
        init() {
            self.chat = .empty()
            self.users = [.vini, .lili, .cris]
            self.alertIsPresented = true
            self.currentUser = authClient.getAuthenticatedUser() ?? User()
        }
    }
    @CasePathable
    enum Action {
        case onAlertCancel
        case onAlertConfirm
        case onAlertInputTextChanged(String)
        case onUserSelected(User)
        case delegate(Delegate)
        
        @CasePathable
        enum Delegate {
            case onNewChatSetup(Chat)
        }
    }
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate(.onNewChatSetup):
                return .none
                
            case .onAlertCancel:
                return .run { _ in
                    await dismiss()
                }
                
            case .onAlertConfirm:
                state.alertIsPresented = false
                return .none
            
            case let .onAlertInputTextChanged(text):
                state.chat.name = text
                return .none
                
            case let .onUserSelected(user):
                state.chat.participants = [state.currentUser, user]
                return .send(.delegate(.onNewChatSetup(state.chat)))
            }
        }
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
        .alert(
            Text("Novo chat"),
            isPresented: .constant(store.alertIsPresented)
        ) {
            Button("Cancelar", role: .cancel) {
                store.send(.onAlertCancel)
            }
            Button("OK") {
                store.send(.onAlertConfirm)
            }
            TextField("Nome", text: Binding(
                get: { store.alertInputText },
                set: { store.send(.onAlertInputTextChanged($0)) }
            )).textContentType(.name)
        } message: {
           Text("Escreva o nome do novo chat")
        }
    }
}
