import AuthClient
import Dependencies
import FirebaseAuth

extension LoginManagerEnvironmentDependency: DependencyKey {
    public static var liveValue: LoginManager = FirebaseLoginManager()
}

extension Login {
    init(user: User) {
        self.init(
            uid: user.uid,
            email: user.email,
            photoURL: user.photoURL?.absoluteString
        )
    }
}

final public class FirebaseLoginManager: LoginManager {
    public func creatUser(email: String, password: String) async throws -> Login {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return Login(user: authDataResult.user)
    }

    public func getAuthenticationUser() throws -> Login {
        guard let user = Auth.auth().currentUser else {
            print("Not authenticated")
            throw URLError(.badServerResponse)
        }

        return Login(user: user)
    }

    public func signIn(email: String, password: String) async throws -> Login {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return Login(user: authDataResult.user)
    }

    public func signOut() throws {
        do {
            try Auth.auth().signOut()
            print("Logout successful")
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }

    public func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
