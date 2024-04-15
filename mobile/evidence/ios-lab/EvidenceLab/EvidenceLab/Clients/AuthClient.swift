import Combine
import Foundation

struct AuthClient {
    let getAuthenticatedUser: () -> User?
    let authenticate: (String, String) -> AnyPublisher<User, Never>
}

extension User {
    static let vini = User(name: "Vini")
    static let cris = User(name: "Cris")
}

extension AuthClient {
    static func authenticated(_ user: User = .vini) -> AuthClient {
        AuthClient(
            getAuthenticatedUser: { user },
            authenticate: { email, password in fatalError() }
        )
    }
    
    static func unauthenticated(onAuthenticate user: User = .vini) -> AuthClient {
        let subject = CurrentValueSubject<User?, Never>(nil)
        return AuthClient(
            getAuthenticatedUser: { subject.value },
            authenticate: { email, password in
                subject.send(user)
                return Just(user).eraseToAnyPublisher()
            }
        )
    }
}
