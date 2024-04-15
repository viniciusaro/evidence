import Combine
import CasePaths
import SwiftUI

struct ProfileFeature: Feature {
    struct State: Equatable {
        var currentUser: User?
    }
    
    @CasePathable
    enum Action {
        case viewDidAppear
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .viewDidAppear:
                guard let user = authClient.getAuthenticatedUser() else {
                    return .none
                }
                state.currentUser = user
                return .none
            }
        }
    )
}

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            VStack {
                if let currentUser = viewStore.currentUser {
                    Text("PROFILE OF \(currentUser.name)")
                } else {
                    Text("NO ONE'S PROFILE")
                }
            }
            .onAppear {
                viewStore.send(.viewDidAppear)
            }
        }
    }
}

