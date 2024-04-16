import Combine
import Foundation
import FirebaseAuth

struct AuthClient {
    let getAuthenticatedUser: () -> User?
    let authenticate: (String, String) -> AnyPublisher<User, Never>
}

extension AuthClient {
    static func authenticated(_ user: User = .vini) -> AuthClient {
        AuthClient(
            getAuthenticatedUser: { user },
            authenticate: { email, password in fatalError() }
        )
    }
    
    static func unauthenticated(_ user: User = .vini) -> AuthClient {
        let subject = CurrentValueSubject<User?, Never>(nil)
        return AuthClient(
            getAuthenticatedUser: { subject.value },
            authenticate: { email, password in
                subject.send(user)
                return Just(user).eraseToAnyPublisher()
            }
        )
    }
    
    static var live = AuthClient(
        getAuthenticatedUser: {
            if let firebaseUser = Auth.auth().currentUser {
                return User(from: firebaseUser)
            }
            return nil
        },
        authenticate: { email, password in
            let subject = PassthroughSubject<User, Never>()
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let result = result {
                    subject.send(User(from: result.user))
                }
            }
            return subject.eraseToAnyPublisher()
        }
    )
}

extension User {
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? firebaseUser.email ?? firebaseUser.description
    }
}
