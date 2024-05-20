import Dependencies

public protocol LoginManager {
    func creatUser(email: String, password: String) async throws -> Login
    func getAuthenticationUser() throws -> Login
    func signIn(email: String, password: String) async throws -> Login
    func signOut() throws
    func resetPassword(email: String) async throws
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

