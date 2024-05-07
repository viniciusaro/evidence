import Combine
import ComposableArchitecture
import Models
import SwiftUI

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State: Equatable {
        var user: User
        init() {
            self.user = authClient.getAuthenticatedUser() ?? User()
        }
    }
    
    @CasePathable
    public enum Action {
    }
    
    public var body: some ReducerOf<Self> {
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

