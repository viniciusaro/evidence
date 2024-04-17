import Combine
import ComposableArchitecture
import SwiftUI

@Reducer
struct ProfileFeature {
    @ObservableState
    struct State: Equatable, Codable {
        var user: User
        init() {
            self.user = authClient.getAuthenticatedUser() ?? User()
        }
    }
    
    @CasePathable
    enum Action {
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack {
            Text("PROFILE OF \(store.user.name)")
        }
    }
}

