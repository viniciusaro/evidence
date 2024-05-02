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

@Reducer
public struct RootFeature {
    public init() {}
    
    @ObservableState
    public enum State {
        case home(HomeFeature.State)
        case login(LoginFeature.State)
        
        public init() {
            if let _ = authClient.getAuthenticatedUser() {
                self = .home(HomeFeature.State())
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
        EmptyReducer().ifLet(\.login, action: \.login) {
            LoginFeature()
        }
        .ifLet(\.home, action: \.home) {
            HomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .home:
                return .none
                
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
        if let homeStore = store.scope(state: \.home, action: \.home) {
            HomeView(store: homeStore)
        } else if let loginStore = store.scope(state: \.login, action: \.login) {
            LoginView(store: loginStore)
        } else {
            fatalError("Invalid Root State")
        }
    }
}
