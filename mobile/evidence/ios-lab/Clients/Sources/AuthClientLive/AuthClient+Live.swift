import AuthClient
import Combine
import Dependencies
import Foundation
import FirebaseAuth
import FirebaseFunctions
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
        },
        signOut: {
            try? Auth.auth().signOut()
        },
        createUser: { email, password in
            let subject = PassthroughSubject<Models.User, Error>()
            let token = Task {
                do {
                    let result = try await Auth.auth().createUser(withEmail: email, password: password)
                    subject.send(Models.User(from: result.user))
                } catch {
                    switch AuthErrorCode(_nsError: error as NSError).code {
                    case .invalidCredential:
                        subject.send(completion: .failure(.invalidCredentials))
                    default:
                        subject.send(completion: .failure(.unknown(error)))
                    }
                }
            }
            
            return subject
                .handleEvents(receiveCancel: { token.cancel() })
                .eraseToAnyPublisher()
        },
        resetPassword: { email in
            let subject = PassthroughSubject<Void, Never>()
            let token = Task {
                try? await Auth.auth().sendPasswordReset(withEmail: email)
                subject.send(())
            }
            return subject
                .handleEvents(receiveCancel: { token.cancel() })
                .eraseToAnyPublisher()
        },
        participantsList: {
            let subject = PassthroughSubject<[Models.User], Never>()
            
            let functions = Functions.functions()
            var callable: HTTPSCallable? = functions.httpsCallable("participantsList")
                
            callable?.call() { result, error in
                if let data = result?.data as? [[String: Any]] {
                    subject.send(data.map { User(name: $0["email"] as! String, id: $0["uid"] as! String) })
//                    subject.send(data)
                } else if let error = error {
//                    subject.send("error: \(error.localizedDescription)")
                } else {
//                    subject.send("error: unknown")
                }
            }
            
            return subject
                .handleEvents(receiveCancel: { callable = nil })
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
