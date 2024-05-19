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

    func createUser(email: String, password: String) async -> Result<Login, LoginError> {
        do {
            let result = try await firebaseAuth.createUser(withEmail: email, password: password)
            return Result.success(Login(user: result.user))
        } catch let error as NSError {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case.invalidEmail:
                    return Result.failure(LoginError.invalidEmail)
                case.emailAlreadyInUse:
                    return Result.failure(LoginError.emailAlreadyInUse)
                case.networkError:
                    return Result.failure(LoginError.networkError)
                case.internalError:
                    return Result.failure(LoginError.internalError)
                case.tooManyRequests:
                    return Result.failure(LoginError.tooManyRequests)
                default:
                    return Result.failure(LoginError.unknown)
                }
            }
            return Result.failure(LoginError.unknown)
        }
    }

    func getAuthenticationUser() -> Result<Login, LoginError> {
        guard let result = firebaseAuth.currentUser else {
            return Result.failure(LoginError.userAuthenticationFailed)
        }
        return Result.success(Login(user: result))
    }

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
                case.internalError:
                    return Result.failure(LoginError.internalError)
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
    
    func signOut() -> Result<Void, LoginError> {
        do {
            let result: Void = try firebaseAuth.signOut()
            return Result.success(result)
        } catch let error as NSError {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case.networkError:
                    return Result.failure(LoginError.networkError)
                default:
                    return Result.failure(LoginError.unknown)
                }
            }
            return Result.failure(LoginError.unknown)
        }
    }

    func resetPassword(email: String) async -> Result<Void, LoginError> {
        do {
            let result: Void = try await firebaseAuth.sendPasswordReset(withEmail: email)
            return Result.success(result)
        } catch let error as NSError {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case.invalidEmail:
                    return Result.failure(LoginError.invalidEmail)
                case.userNotFound:
                    return Result.failure(LoginError.userNotFound)
                case.networkError:
                    return Result.failure(LoginError.networkError)
                case.internalError:
                    return Result.failure(LoginError.internalError)
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
}

final public class AuthenticatedLoginManager: LoginManager {
    func createUser(email: String, password: String) async -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    func getAuthenticationUser() -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    func signIn(email: String, password: String) async -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    func signOut() -> Result<Void, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    func resetPassword(email: String) async -> Result<Void, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }
}

final public class FailureAuthenticationLoginManager: LoginManager {
    func createUser(email: String, password: String) async -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    func getAuthenticationUser() -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    func signIn(email: String, password: String) async -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    func signOut() -> Result<Void, LoginError> {
        return Result.failure(LoginError.internalError)
    }

    func resetPassword(email: String) async -> Result<Void, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }
}
