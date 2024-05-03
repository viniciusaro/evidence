import SwiftUI

class LoginModel: ObservableObject {
    
}

struct LoginViewMVVM: View {
    @ObservedObject var model: LoginModel
    
    var body: some View {
        EmptyView()
    }
}
