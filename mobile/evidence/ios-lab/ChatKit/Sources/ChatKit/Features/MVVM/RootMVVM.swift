import SwiftUI

@Observable
public class RootModel {
    var root: Model
    
    enum Model {
        case home(HomeModel)
        case login(LoginModel)
    }
    
    init() {
        if let _ = authClient.getAuthenticatedUser() {
            self.root = .home(HomeModel())
        } else {
            self.root = .login(LoginModel())
        }
    }
}

public struct RootViewMVVM: View {
    let model: RootModel
    
    public init(model: RootModel) {
        self.model = model
    }
    
    public var body: some View {
        switch model.root {
        case let .home(homeModel):
            HomeViewMVVM(model: homeModel)
        case let .login(loginModel):
            LoginViewMVVM(model: loginModel)
        }
    }
}
