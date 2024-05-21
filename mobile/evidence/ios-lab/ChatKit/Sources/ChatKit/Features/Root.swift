import Combine
import ComposableArchitecture
import SwiftUI

@Reducer
public struct RootFeature {
    @Dependency(\.authClient) static var authClient
    
    @ObservableState
    public enum State {
        case home(HomeFeature.State)
        case login(LoginViewModel)
        
        public init() {
            if let _ = authClient.getAuthenticatedUser() {
                self = .home(HomeFeature.State())
            } else {
                self = .login(LoginViewModel())
            }
        }
    }
    
    public enum Action {
        case home(HomeFeature.Action)
        case onUserAuthenticated
        case redirectToLogin
    }
    
    public var body: some ReducerOf<Self> {
        EmptyReducer().ifLet(\.home, action: \.home) {
            HomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .home(.profile(.onSignOutButtonTapped)):
                return .concatenate(
                    .send(.home(.chatList(.beforeViewUnload))),
                    .send(.redirectToLogin)
                )
                
            case .home:
                return .none
                
            case .redirectToLogin:
                state = .login(LoginViewModel())
                return .none
                
            case .onUserAuthenticated:
                state = .home(HomeFeature.State())
                return .none
            }
        }
    }
        
    public init() {}
}

public struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>
    
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        if let homeStore = store.scope(state: \.home, action: \.home) {
            HomeView(store: homeStore)
        } else if case let .login(viewModel) = store.state {
            LoginView(viewModel: viewModel)
                .onViewDidLoad {
                    viewModel.delegateUserAuthenticated = {
                        store.send(.onUserAuthenticated)
                    }
                }
        } else {
            fatalError("Invalid Root State")
        }
    }
}

