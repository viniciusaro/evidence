import SwiftUI

@Observable
class ProfileModel {
    var user: User
    
    init() {
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
