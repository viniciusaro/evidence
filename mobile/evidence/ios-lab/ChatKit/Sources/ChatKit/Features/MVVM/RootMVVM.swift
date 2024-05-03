import SwiftUI

public class RootModel: ObservableObject {
    @Published var root: State
    
    enum State {
        case home(HomeModel)
        case login(LoginModel)
    }
    
    public init() {
        if let _ = authClient.getAuthenticatedUser() {
            self.root = .home(HomeModel())
        } else {
            self.root = .login(LoginModel())
        }
    }
}

public struct RootViewMVVM: View {
    @ObservedObject var model: RootModel
    
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
