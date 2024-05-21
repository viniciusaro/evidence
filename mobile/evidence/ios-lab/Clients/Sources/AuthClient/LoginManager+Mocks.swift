import Foundation

final public class AuthenticatedLoginManager: LoginManager {
    public func createUser(email: String, password: String) async -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    public func getAuthenticationUser() -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    public func signIn(email: String, password: String) async -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    public func signOut() -> Result<Void, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    public func resetPassword(email: String) async -> Result<Void, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }
}

final public class FailureAuthenticationLoginManager: LoginManager {
    public func createUser(email: String, password: String) async -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    public func getAuthenticationUser() -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    public func signIn(email: String, password: String) async -> Result<Login, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }

    public func signOut() -> Result<Void, LoginError> {
        return Result.failure(LoginError.internalError)
    }

    public func resetPassword(email: String) async -> Result<Void, LoginError> {
        return Result.failure(LoginError.emailNotProvide)
    }
}
