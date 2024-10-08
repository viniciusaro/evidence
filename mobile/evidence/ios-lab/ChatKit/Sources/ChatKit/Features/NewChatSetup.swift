import AuthClient
import ComposableArchitecture
import Models
import SwiftUI

@Reducer 
public struct NewChatSetupFeature {
    @Dependency(\.authClient) var authClient
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    public struct State: Equatable {
        var chat: Chat
        var users: [User]
        var alertIsPresented: Bool
        var currentUser: User
        
        init() {
            @Dependency(\.authClient) var authClient
            
            self.chat = .empty()
            self.users = []
            self.alertIsPresented = true
            self.currentUser = authClient.getAuthenticatedUser() ?? User()
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAlertCancel
        case onAlertConfirm
        case onUserSelected(User)
        case onUsersLoaded([User])
        case onViewDidLoad
        case delegate(Delegate)
        
        public enum Delegate {
            case onNewChatSetup(Chat)
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .delegate(.onNewChatSetup):
                return .none
                
            case .onAlertCancel:
                return .run { _ in
                    await dismiss()
                }
                
            case .onAlertConfirm:
                state.alertIsPresented = false
                return .none
            
            case let .onUserSelected(user):
                state.chat.participants = [state.currentUser, user]
                return .send(.delegate(.onNewChatSetup(state.chat)))
        
            case let .onUsersLoaded(users):
                state.users = users
                return .none
                
            case .onViewDidLoad:
                return .publisher {
                    authClient.participantsList()
                        .receive(on: DispatchQueue.main)
                        .map { .onUsersLoaded($0) }
                }
            }
        }
        BindingReducer()
    }
}

struct NewChatSetupView: View {
    @Bindable var store: StoreOf<NewChatSetupFeature>
    
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
        .onViewDidLoad {
            store.send(.onViewDidLoad)
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
            TextField("Nome", text: $store.chat.name).textContentType(.name)
        } message: {
           Text("Escreva o nome do novo chat")
        }
    }
}
