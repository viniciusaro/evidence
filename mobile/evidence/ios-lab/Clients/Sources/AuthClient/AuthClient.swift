import Combine
import Dependencies
import Models
import Foundation

public struct AuthClient {
    public let getAuthenticatedUser: () -> User?
    public let authenticate: (String, String) -> AnyPublisher<User, Error>
    public let createUser: (String, String) -> AnyPublisher<User, Error>
    public let signOut: () -> Void
    public let resetPassword: (String) -> AnyPublisher<Void, Never>
    
    public enum Error: Swift.Error {
        case invalidCredentials
        case credentialAlreadyInUse
        case unknown(Swift.Error)
    }
    
    public init(
        getAuthenticatedUser: @escaping () -> User?,
        authenticate: @escaping (String, String) -> AnyPublisher<User, Error>,
        signOut: @escaping () -> Void,
        createUser: @escaping (String, String) -> AnyPublisher<User, Error>,
        resetPassword: @escaping (String) -> AnyPublisher<Void, Never>
    ) {
        self.getAuthenticatedUser = getAuthenticatedUser
        self.authenticate = authenticate
        self.signOut = signOut
        self.createUser = createUser
        self.resetPassword = resetPassword
    }
}

extension AuthClient: TestDependencyKey {
    public static let testValue = AuthClient.authenticated()
    public static let previewValue = AuthClient.authenticated()
}

extension DependencyValues {
    public var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
