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
    private let firebaseAuth = Auth.auth()

    public func createUser(email: String, password: String) async -> Result<Login, LoginError> {
        do {
            let result = try await firebaseAuth.createUser(withEmail: email, password: password)
            return Result.success(Login(user: result.user))
        } catch let error as NSError {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case.invalidCredential:
                    return Result.failure(LoginError.invalidCredential)
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

    public func getAuthenticationUser() -> Result<Login, LoginError> {
        guard let result = firebaseAuth.currentUser else {
            return Result.failure(LoginError.userAuthenticationFailed)
        }
        return Result.success(Login(user: result))
    }

    public func signIn(email: String, password: String) async -> Result<Login, LoginError> {
        do {
            let result = try await firebaseAuth.signIn(withEmail: email, password: password)
            return Result.success(Login(user: result.user))
        } catch let error as NSError {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case.invalidCredential:
                    return Result.failure(LoginError.invalidCredential)
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
    
    public func signOut() -> Result<Void, LoginError> {
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

    public func resetPassword(email: String) async -> Result<Void, LoginError> {
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
