import Combine
import Models

extension AuthClient {
    public static func authenticated(_ user: User = .vini) -> AuthClient {
        let subject = CurrentValueSubject<User?, Never>(user)
        return AuthClient(
            getAuthenticatedUser: { subject.value },
            authenticate: { email, password in
                subject.send(user)
                return Just(user)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            signOut: {
                subject.send(nil)
            },
            createUser: { email, password in
                subject.send(user)
                return Just(user)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            resetPassword: { email in
                return Just(())
                    .eraseToAnyPublisher()
            },
            participantsList: {
                return Just([])
                    .eraseToAnyPublisher()
            }
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
            },
            signOut: {
                subject.send(nil)
            },
            createUser: { email, password in
                subject.send(user)
                return Just(user)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            resetPassword: { email in
                return Just(())
                    .eraseToAnyPublisher()
            },
            participantsList: {
                return Just([])
                    .eraseToAnyPublisher()
            }
        )
    }
}

