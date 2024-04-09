import Combine
import CasePaths
import SwiftUI

struct ProfileFeature: Feature {
    struct State: Equatable {
        var currentUser: User?
    }
    
    @CasePathable
    enum Action {
        case profileLoad
        case currentUserUpdate(User?)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .profileLoad:
                return .publisher(
                    authClient.getAuthenticatedUser()
                        .map { .currentUserUpdate($0) }
                )
            
            case let .currentUserUpdate(user):
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
            .onViewDidLoad {
                viewStore.send(.profileLoad)
            }
        }
    }
}

