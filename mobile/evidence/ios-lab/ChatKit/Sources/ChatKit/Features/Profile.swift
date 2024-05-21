import Combine
import ComposableArchitecture
import Models
import Leaf
import SwiftUI

#Preview {
    LeafThemeView {
        ProfileView(store: Store(initialState: .init()) {
            ProfileFeature()
        })
    }
}

@Reducer
public struct ProfileFeature {
    @Dependency(\.authClient) static var authClient
    
    @ObservableState
    public struct State: Equatable {
        var user: User
        init() {
            self.user = authClient.getAuthenticatedUser() ?? User()
        }
    }
    
    public enum Action {
        case onSignOutButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onSignOutButtonTapped:
                return .run { _ in
                    ProfileFeature.authClient.signOut()
                }
            }
        }
    }
}

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack {
            Text("PROFILE OF \(store.user.name)")
            Button("Sair", role: .cancel) {
                store.send(.onSignOutButtonTapped)
            }
            .buttonStyle(LeafPrimaryButtonStyle())
        }
        .padding(20)
    }
}

