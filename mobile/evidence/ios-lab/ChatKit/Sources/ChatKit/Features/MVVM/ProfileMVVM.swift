import SwiftUI

class ProfileModel: ObservableObject {
    @Published var user: User
    
    init() {
        self.user = authClient.getAuthenticatedUser() ?? User()
    }
}

struct ProfileViewMVVM: View {
    @ObservedObject var model: ProfileModel
    
    var body: some View {
        VStack {
            Text("PROFILE OF \(model.user.name)")
        }
    }
}
