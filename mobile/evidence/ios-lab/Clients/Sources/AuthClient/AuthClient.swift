import Combine
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
