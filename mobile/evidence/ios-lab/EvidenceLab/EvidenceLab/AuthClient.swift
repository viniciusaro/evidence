import Combine
import Foundation

struct AuthClient {
    let getAuthenticatedUser: () -> AnyPublisher<User?, Never>
    let authenticate: (String, String) -> AnyPublisher<User, Never>
}

extension AuthClient {
    static func authenticated(_ user: User = .vini) -> AuthClient {
        AuthClient(
            getAuthenticatedUser: { Just(user).eraseToAnyPublisher() },
            authenticate: { email, password in fatalError() }
        )
    }
    
    static func unauthenticated(onAuthenticate user: User = .vini) -> AuthClient {
        let subject = CurrentValueSubject<User?, Never>(nil)
        return AuthClient(
            getAuthenticatedUser: { subject.eraseToAnyPublisher() },
            authenticate: { email, password in
                subject.send(user)
                return Just(user).eraseToAnyPublisher()
            }
        )
    }
    
    static let switchAccount = intermitent(.vini, .cris)
    
    static func intermitent(_ user1: User?, _ user2: User?) -> AuthClient {
        AuthClient(
            getAuthenticatedUser: {
                var user: User? = user1
                return Publishers.Concatenate(
                    prefix: Just(user1),
                    suffix: Timer.publish(every: 5, on: .main, in: .default)
                        .autoconnect()
                        .map { _ in user == user1 ? user2 : user1 }
                    )
                    .handleEvents(receiveOutput: { user = $0 })
                    .eraseToAnyPublisher()
                    
            },
            authenticate: { email, password in Just(.vini).eraseToAnyPublisher() }
        )
    }
}
