import Combine
import CasePaths
import SwiftUI

struct LoginFeature: Feature {
    struct State: Equatable, Identifiable {
        let id = UUID()
    }
    
    @CasePathable
    enum Action {
        case submitButtonTapped(String, String)
        case userAuthenticated(User)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case let .submitButtonTapped(username, password):
                return .publisher(
                    authClient.authenticate(username, password)
                        .map { .userAuthenticated($0) }
                )
            case .userAuthenticated:
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
                viewStore.send(.submitButtonTapped("user", "password"))
            }, label: {
                Text("Entrar")
            })
        }
    }
}

