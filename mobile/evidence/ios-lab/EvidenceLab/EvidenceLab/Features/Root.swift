import Combine
import ComposableArchitecture
import SwiftUI

let authClient = AuthClient.authenticated()
let dataClient = DataClient.live

//#Preview {
//    RootView(
//        store: Store(
//            initialState: RootFeature.State(),
//            reducer: RootFeature.reducer
//        )
//    )
//}

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var home: HomeFeature.State = .init()
        var login: LoginFeature.State? = nil
    }
    
    @CasePathable
    enum Action {
        case home(HomeFeature.Action)
        case login(LoginFeature.Action)
        case viewDidLoad
        case unauthenticatedUserModalDismissed
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .home:
                return .none
                
            case .login(.onUserAuthenticated):
                state.login = nil
                return .none
                
            case .login:
                return .none
                
            case .viewDidLoad:
                let user = authClient.getAuthenticatedUser()
                state.login = user == nil ? LoginFeature.State() : nil
                return .none
                
            case .unauthenticatedUserModalDismissed:
                return .none
            }
        }
        Scope(state: \.home, action: \.home) {
                HomeFeature()
        }
        .ifLet(\.login, action: \.login) {
            LoginFeature()
        }
        Reduce { state, action in
            var chats = state.home.chatList.chats
            let detailState = state.home.chatList.detail
            
            if let detailState = detailState {
                chats[id: detailState.chat.id] = detailState.chat
            }
            
            return .run { [chats = chats] _ in
                let data = try JSONEncoder().encode(chats)
                try dataClient.save(data, .chats)
            }
        }
    }
}

struct RootView: View {
    let store: StoreOf<RootFeature>
    
    var body: some View {
        HomeView(
            store: store.scope(state: \.home, action: \.home)
        )
        .onViewDidLoad {
            store.send(.viewDidLoad)
        }
        .sheet(item: Binding(
            get: { store.login },
            set: { _ in store.send(.unauthenticatedUserModalDismissed) }
        )) { loginState in
            LoginView(store: store.scope(state: \.login!, action: \.login))
        }
    }
}

