import Combine
import Dependencies
import Models
import Foundation

public struct AuthClient {
    public let getAuthenticatedUser: () -> User?
    public let authenticate: (String, String) -> AnyPublisher<User, Error>
    
    public enum Error: Swift.Error {
        case invalidCredentials
        case credentialAlreadyInUse
        case unknown(Swift.Error)
    }
    
    public init(
        getAuthenticatedUser: @escaping () -> User?,
        authenticate: @escaping (String, String) -> AnyPublisher<User, Error>
    ) {
        self.getAuthenticatedUser = getAuthenticatedUser
        self.authenticate = authenticate
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

extension AuthClient {
    public static func authenticated(_ user: User = .vini) -> AuthClient {
        AuthClient(
            getAuthenticatedUser: { user },
            authenticate: { email, password in fatalError() }
        )
    }
    
    public static func unauthenticated(_ user: User = .vini) -> AuthClient {
        let subject = CurrentValueSubject<User?, Never>(nil)
        return AuthClient(
            getAuthenticatedUser: { subject.value },
            authenticate: { email, password in
                subject.send(user)
                return Just(user)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )
    }
}
