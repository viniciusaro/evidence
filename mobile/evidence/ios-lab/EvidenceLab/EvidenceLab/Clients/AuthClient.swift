import Combine
import Foundation
import FirebaseAuth

struct AuthClient {
    let getAuthenticatedUser: () -> User?
    let authenticate: (String, String) -> AnyPublisher<User, Error>
    
    enum Error: Swift.Error {
        case invalidCredentials
        case credentialAlreadyInUse
        case unknown(Swift.Error)
    }
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
                return Just(user)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
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
            let subject = PassthroughSubject<User, Error>()
            
            let token = Task {
                do {
                    let result = try await Auth.auth().createUser(withEmail: email, password: password)
                    subject.send(User(from: result.user))
                } catch {
                    if AuthErrorCode(_nsError: error as NSError).code == .emailAlreadyInUse {
                        do {
                            let result = try await Auth.auth().signIn(withEmail: email, password: password)
                            subject.send(User(from: result.user))
                        }
                        catch {
                            switch AuthErrorCode(_nsError: error as NSError).code {
                            case .invalidCredential:
                                subject.send(completion: .failure(.invalidCredentials))
                            default:
                                subject.send(completion: .failure(.unknown(error)))
                            }
                        }
                    }
                }
            }
            
            return subject
                .handleEvents(receiveCancel: { token.cancel() })
                .eraseToAnyPublisher()
        }
    )
}

extension User {
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? firebaseUser.email ?? firebaseUser.description
    }
}
