import Combine
import ComposableArchitecture
import SwiftUI

@Reducer
struct ProfileFeature {
    @ObservableState
    struct State: Equatable {
        var currentUser: User?
    }
    
    @CasePathable
    enum Action {
        case viewDidAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewDidAppear:
                guard let user = authClient.getAuthenticatedUser() else {
                    return .none
                }
                state.currentUser = user
                return .none
            }
        }
    }
}

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack {
            if let currentUser = store.currentUser {
                Text("PROFILE OF \(currentUser.name)")
            } else {
                Text("NO ONE'S PROFILE")
            }
        }
        .onAppear {
            store.send(.viewDidAppear)
        }
    }
}

