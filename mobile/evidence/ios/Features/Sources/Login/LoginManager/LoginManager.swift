//
//  File.swift
//
//  LoginManager.swift

import Foundation
import FirebaseAuth

struct Login {
    let uid: String
    let email: String?
    let photoURL: String?
}

extension Login {
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

final public class FirebaseLoginManager: LoginManager {
    func creatUser(email: String, password: String) async throws -> Login {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return Login(user: authDataResult.user)
    }

    func getAuthenticationUser() throws -> Login {
        guard let user = Auth.auth().currentUser else {
            print("Not authenticated")
            throw URLError(.badServerResponse)
        }

        return Login(user: user)
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
            print("Logout successful")
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }

    func signIn(email: String, password: String) async throws -> Login {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return Login(user: authDataResult.user)
    }
}

final public class AuthenticatedLoginManager: LoginManager {
    
    var authenticatedUser: Login?

    func creatUser(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    func getAuthenticationUser() throws -> Login {
        let uid = UUID().uuidString
        let userAuth = Login(uid: uid, email: "email@test.com", photoURL: "photo_url")
        authenticatedUser = userAuth

        guard let user = authenticatedUser else {
            throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        return user
    }
    
    func signOut() throws {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }
    
    func signIn(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }
}

final public class FailureAuthenticationLoginManager: LoginManager {

    func creatUser(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    func getAuthenticationUser() throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    func signOut() throws {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    func signIn(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }
}
