import Combine
import CasePaths
import SwiftUI

let authClient = AuthClient.authenticated()
let dataClient = DataClient.live

#Preview {
    RootView(
        store: Store(
            initialState: RootFeature.State(),
            reducer: RootFeature.reducer
        )
    )
}

struct RootFeature: Feature {
    struct State: Equatable {
        var home: HomeFeature.State = .init()
        var login: LoginFeature.State? = nil
    }
    
    @CasePathable
    enum Action {
        case currentUserUpdate(User?)
        case home(HomeFeature.Action)
        case login(LoginFeature.Action)
        case viewDidLoad
        case unauthenticatedUserModalDismissed
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case let .currentUserUpdate(user):
                state.login = user == nil ? LoginFeature.State() : nil
                return .none
                
            case .home:
                return .none
                
            case .login:
                return .none
    
            case .viewDidLoad:
                return .publisher(
                    authClient.getAuthenticatedUser()
                        .map { .currentUserUpdate($0) }
                        .receive(on: DispatchQueue.main)
                )

            case .unauthenticatedUserModalDismissed:
                return .none
            }
        },
        .scope(state: \.home, action: \.home) {
            HomeFeature.reducer
        },
        .ifLet(state: \.login, action: \.login) {
            LoginFeature.reducer
        },
        Reducer { state, action in
            .fireAndForget { [chats = state.home.chatList.chats] in
                let data = try JSONEncoder().encode(chats)
                try dataClient.save(data, .chats)
            }
        }
    )
}

struct RootView: View {
    let store: StoreOf<RootFeature>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            HomeView(
                store: store.scope(state: \.home, action: \.home)
            )
            .onViewDidLoad {
                viewStore.send(.viewDidLoad)
            }
            .sheet(item: Binding(
                get: { viewStore.login },
                set: { _ in viewStore.send(.unauthenticatedUserModalDismissed) }
            )) { loginState in
                LoginView(store: store.scope(state: { _ in loginState }, action: \.login))
            }
        }
    }
}

