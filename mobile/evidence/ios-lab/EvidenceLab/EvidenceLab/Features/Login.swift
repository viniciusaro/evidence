import Combine
import ComposableArchitecture
import SwiftUI

#Preview {
    LoginView(
        store: Store(
            initialState: LoginFeature.State(),
            reducer: { LoginFeature() }
        )
    )
}

@Reducer
struct LoginFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
        var emailInput: String = ""
        var passwordInput: String = ""
    }
    
    @CasePathable
    enum Action {
        case onSubmitButtonTapped
        case onUserAuthenticated(User)
        case onEmailInputChanged(String)
        case onPasswordInputChanged(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onEmailInputChanged(email):
                state.emailInput = email
                return .none
                
            case let .onPasswordInputChanged(password):
                state.passwordInput = password
                return .none
                
            case .onSubmitButtonTapped:
                let username = state.emailInput
                let password = state.passwordInput
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
        VStack(alignment: .leading, spacing: 20) {
            Section("Informações de acesso") {
                TextField("Email", text: Binding(
                    get: { store.emailInput },
                    set: { store.send(.onEmailInputChanged($0)) }
                ))
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                
                TextField("Senha", text: Binding(
                    get: { store.passwordInput },
                    set: { store.send(.onPasswordInputChanged($0)) }
                ))
                .textContentType(.password)
            }
            Section {
                Button(action: {
                    store.send(.onSubmitButtonTapped)
                }, label: {
                    Text("Entrar")
                })
            }
        }
        .padding()
    }
}

