//
//  File.swift
//  
//
//  Created by Cris Messias on 01/02/24.
//

import Foundation
import FirebaseAuth

struct Login {
    let uid: String
    let email: String?
    let photoURL: String?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

final public class LoginManager {
    static var shared = LoginManager()
    private init() {}

    func creatUser(email: String, password: String) async throws -> Login {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return Login(user: authDataResult.user)
    }
    
    func getAuthenticationUser() throws -> Login {
        guard let user = Auth.auth().currentUser else {
            print("error")
            throw URLError(.badServerResponse)
        }

        return Login(user: user)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func userEmailLogged() {
        let authUser = try? LoginManager.shared.getAuthenticationUser()
        _ = authUser?.email
    }
}
