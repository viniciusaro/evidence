//
//  LoginManager.swift
//
//  Created by Cris Messias on 01/02/24.
//

import Foundation
import FirebaseAuth
import Models

extension Login {
    init(user: User) {
        self = Login(
            uid: user.uid,
            email: user.email,
            photoUrl: user.photoURL?.absoluteString
        )
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
}

final public class AuthenticatedLoginManager: LoginManager {
    var authenticatedUser: Login?

    func creatUser(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }
    
    func getAuthenticationUser() throws -> Login {
        let uid = UUID().uuidString
        let userAuth = Login(uid: uid, email: "email@test.com", photoUrl: "photo_url")
        authenticatedUser = userAuth
        
        guard let user = authenticatedUser else {
            throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        return user
    }
    
    func signOut() throws {
        guard authenticatedUser != nil else {
            throw NSError(domain: "signOut", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        authenticatedUser = nil
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
}
