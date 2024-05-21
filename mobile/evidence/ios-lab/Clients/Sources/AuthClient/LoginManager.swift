import Dependencies

public protocol LoginManager {
    func createUser(email: String, password: String) async -> Result<Login, LoginError>
    func getAuthenticationUser() -> Result<Login, LoginError>
    func signIn(email: String, password: String) async -> Result<Login, LoginError>
    func signOut() -> Result<Void, LoginError>
    func resetPassword(email: String) async -> Result<Void, LoginError>
}

public struct Login {
    public let uid: String
    public let email: String?
    public let photoURL: String?
    
    public init(uid: String, email: String?, photoURL: String?) {
        self.uid = uid
        self.email = email
        self.photoURL = photoURL
    }
}

public struct LoginManagerEnvironmentDependency: TestDependencyKey {
    public static var testValue: LoginManager = AuthenticatedLoginManager()
    public static var previewValue: LoginManager = AuthenticatedLoginManager()
}

extension DependencyValues {
    public var loginManager: LoginManager {
        get { self[LoginManagerEnvironmentDependency.self] }
        set { self[LoginManagerEnvironmentDependency.self] = newValue }
    }
}

