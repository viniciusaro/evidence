import Combine
import ComposableArchitecture
import SwiftUI

#if DEBUG
var authClient = AuthClient.live
var dataClient = DataClient.live
var stockClient = StockClient.live
var installationClient = InstallationClient.mock("1")
#else
let authClient = AuthClient.live
let dataClient = DataClient.live
let stockClient = StockClient.live
let installationClient = InstallationClient.mock("1")
#endif

#Preview {
    dataClient = DataClient.mock(Chat.mockList)
    
    return RootView(
        store: Store(
            initialState: RootFeature.State(),
            reducer: { RootFeature() }
        )
    )
}

@Reducer
public struct RootFeature {
    public init() {}
    
    @ObservableState
    public enum State {
        case home(HomeFeature.State)
        case login(LoginFeature.State)
        
        public init() {
            if let _ = authClient.getAuthenticatedUser() {
//                do {
//                    let data = try dataClient.load(.state)
//                    let homeState = try JSONDecoder().decode(HomeFeature.State.self, from: data)
//                    self = .home(homeState)
//                } catch {
                    self = .home(HomeFeature.State())
//                }
            } else {
                self = .login(LoginFeature.State())
            }
        }
    }
    
    @CasePathable
    public enum Action {
        case home(HomeFeature.Action)
        case login(LoginFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        EmptyReducer()
        .ifLet(\.login, action: \.login) {
            LoginFeature()
        }
        .ifLet(\.home, action: \.home) {
            HomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .home:
                guard case let .home(homeState) = state else {
                    return .none
                }
                return .run { [state = homeState] _ in
//                    try JSONEncoder().encode(state).write(to: .state)
                }

            case .login(.onUserAuthenticated):
                state = .home(HomeFeature.State())
                return .none

            case .login:
                return .none
            }
        }
    }
}

public struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>
    
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            if let homeStore = store.scope(state: \.home, action: \.home) {
                HomeView(store: homeStore)
            } else if let loginStore = store.scope(state: \.login, action: \.login) {
                LoginView(store: loginStore)
            } else {
                fatalError("Invalid Root State")
            }
        }
    }
}

