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
    private let firebaseAuth = Auth.auth()
    
    func signIn(email: String, password: String) async -> Result<Login, LoginError> {
        do {
            let result = try await firebaseAuth.signIn(withEmail: email, password: password)
            return Result.success(Login(user: result.user))
        } catch let error as NSError {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case.invalidCredential: 
                    return Result.failure(LoginError.invalidEmailOrPassword)
                case.userNotFound:
                    return Result.failure(LoginError.userNotFound)
                case.networkError:
                    return Result.failure(LoginError.networkError)
                case.userDisabled:
                    return Result.failure(LoginError.userDisabled)
                case.tooManyRequests:
                    return Result.failure(LoginError.tooManyRequests)
                default:
                    return Result.failure(LoginError.unknown)
                }
            }
            return Result.failure(LoginError.unknown)
        }
    }

    func createUser(email: String, password: String) async throws -> Login {
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

    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

final public class AuthenticatedLoginManager: LoginManager {
    var resetPasswordCalled = false
    var authenticatedUser: Login?

    func createUser(email: String, password: String) async throws -> Login {
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

    func signIn(email: String, password: String) async -> Result<Login, LoginError> {
        do {
            throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        } catch {
            return Result.failure(LoginError.emailOrPasswordNotProvide)
        }
    }

    func signOut() throws {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    func resetPassword(email: String) {
        print("Simulated password reset for email: \(email)")
        resetPasswordCalled = true
    }
}

final public class FailureAuthenticationLoginManager: LoginManager {

    func createUser(email: String, password: String) async throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    func getAuthenticationUser() throws -> Login {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    func signIn(email: String, password: String) async -> Result<Login, LoginError> {
        do {
            throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        } catch {
            return Result.failure(LoginError.emailOrPasswordNotProvide)
        }
    }
    func signOut() throws {
        throw NSError(domain: "AuthenticationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    func resetPassword(email: String) {

    }
}
