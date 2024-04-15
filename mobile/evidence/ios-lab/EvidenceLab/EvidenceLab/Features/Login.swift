import Combine
import ComposableArchitecture
import SwiftUI

@Reducer
struct LoginFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
    }
    
    @CasePathable
    enum Action {
        case onSubmitButtonTapped(String, String)
        case onUserAuthenticated(User)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onSubmitButtonTapped(username, password):
                return .publisher {
                    authClient.authenticate(username, password)
                        .first()
                        .map { .onUserAuthenticated($0) }
                }
                
            case .onUserAuthenticated:
                return .none
            }
        }
    }
}

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    
    var body: some View {
        Button(action: {
            store.send(.onSubmitButtonTapped("user", "password"))
        }, label: {
            Text("Entrar")
        })
    }
}

