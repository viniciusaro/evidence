import Combine
import CasePaths
import SwiftUI

struct LoginFeature: Feature {
    struct State: Equatable, Identifiable {
        let id = UUID()
    }
    
    @CasePathable
    enum Action {
        case onSubmitButtonTapped(String, String)
        case onUserAuthenticated(User)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case let .onSubmitButtonTapped(username, password):
                return .publisher(
                    authClient.authenticate(username, password)
                        .map { .onUserAuthenticated($0) }
                )
                
            case .onUserAuthenticated:
                return .none
            }
        }
    )
}

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            Button(action: {
                viewStore.send(.onSubmitButtonTapped("user", "password"))
            }, label: {
                Text("Entrar")
            })
        }
    }
}

