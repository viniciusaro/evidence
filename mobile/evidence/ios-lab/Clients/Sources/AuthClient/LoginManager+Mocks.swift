import Foundation

final public class AuthenticatedLoginManager: LoginManager {
    var resetPasswordCalled = false
    var authenticatedUser: Login?

    public func creatUser(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    public func getAuthenticationUser() throws -> Login {
        let uid = UUID().uuidString
        let userAuth = Login(uid: uid, email: "email@test.com", photoURL: "photo_url")
        authenticatedUser = userAuth

        guard let user = authenticatedUser else {
            throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        return user
    }

    public func signIn(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    public func signOut() throws {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    public func resetPassword(email: String) {
        print("Simulated password reset for email: \(email)")
        resetPasswordCalled = true
    }
}

final public class FailureAuthenticationLoginManager: LoginManager {

    public func creatUser(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    public func getAuthenticationUser() throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }


    public func signIn(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    public func signOut() throws {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    public func resetPassword(email: String) {

    }
}

