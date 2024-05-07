import Dependencies
import Models
import SwiftUI

@Observable
class ProfileModel {
    var user: User
    
    init() {
        @Dependency(\.authClient) var authClient
        self.user = authClient.getAuthenticatedUser() ?? User()
    }
}

struct ProfileViewMVVM: View {
    let model: ProfileModel
    
    var body: some View {
        VStack {
            Text("PROFILE OF \(model.user.name)")
        }
    }
}
