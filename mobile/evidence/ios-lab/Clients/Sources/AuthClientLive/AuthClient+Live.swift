import AuthClient
import Combine
import Dependencies
import Foundation
import FirebaseAuth
import Models

extension AuthClient: DependencyKey {
    public static var liveValue = AuthClient(
        getAuthenticatedUser: {
            if let firebaseUser = Auth.auth().currentUser {
                return User(from: firebaseUser)
            }
            return nil
        },
        authenticate: { email, password in
            let subject = PassthroughSubject<Models.User, Error>()
            
            let token = Task {
                do {
                    let result = try await Auth.auth().createUser(withEmail: email, password: password)
                    subject.send(Models.User(from: result.user))
                } catch {
                    if AuthErrorCode(_nsError: error as NSError).code == .emailAlreadyInUse {
                        do {
                            let result = try await Auth.auth().signIn(withEmail: email, password: password)
                            subject.send(Models.User(from: result.user))
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

extension Models.User {
    init(from firebaseUser: FirebaseAuth.User) {
        self.init(
            name: firebaseUser.displayName ?? firebaseUser.email ?? firebaseUser.description,
            id: firebaseUser.uid
        )
    }
}
