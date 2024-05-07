import AuthClient
import Combine
import ComposableArchitecture
import Models
import SwiftUI

@Reducer 
public struct LoginFeature {
    @ObservableState 
    public struct State: Equatable, Identifiable {
        public let id = UUID()
        var emailInput: String = ""
        var passwordInput: String = ""
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onSubmitButtonTapped
        case onUserAuthenticated(User)
        case onUserAuthenticationError(AuthClient.Error)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onSubmitButtonTapped:
                let username = state.emailInput
                let password = state.passwordInput
                return .publisher {
                    authClient.authenticate(username, password)
                        .first()
                        .map { .onUserAuthenticated($0) }
                        .catch { Just(.onUserAuthenticationError($0)) }
                        .receive(on: DispatchQueue.main)
                }
                
            case .onUserAuthenticated:
                return .none
                
            case let .onUserAuthenticationError(error):
                print("error: \(error)")
                return .none
            }
        }
        BindingReducer()
    }
}

struct LoginView: View {
    @Bindable var store: StoreOf<LoginFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Section("Informações de acesso") {
                TextField("Email", text: $store.emailInput)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                
                TextField("Senha", text: $store.passwordInput)
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

