import Combine
import FirebaseFirestore
import Foundation

struct StockClient {
    let consume: () -> AnyPublisher<Chat, Never>
    let send: (Message, Chat) -> AnyPublisher<Void, Never>
}

extension StockClient {
    static let empty = StockClient(
        consume: { Empty().eraseToAnyPublisher() },
        send: { _, _ in Empty().eraseToAnyPublisher() }
    )
    
    static func mock(_ using: [Chat], interval: Double = 5) -> StockClient {
        StockClient(
            consume: {
                Timer.publish(every: interval, on: .main, in: .default)
                    .autoconnect()
                    .map { _ in Chat.random(using: using) }
                    .eraseToAnyPublisher()
            },
            send: { _, _ in Empty().eraseToAnyPublisher() }
        )
    }
    
    static let live = StockClient(
        consume: {
            let subject = PassthroughSubject<Chat, Never>()
            
            let userId = authClient.getAuthenticatedUser()!.id
            let installationId = installationClient.getCurrentInstallationId()

            let listenerId = Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("installation")
                .document(installationId)
                .collection("stock")
                .addSnapshotListener { snapshot, error in
                    if let snapshot = snapshot {
                        let chats = try? snapshot.documents.compactMap { document in
                            let data = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                            let chats = try JSONDecoder().decode(Chat.self, from: data)
                            return chats
                        }
                        chats?.forEach(subject.send)
                        
                        snapshot.documents.forEach { documentSnapshot in
                            Firestore.firestore()
                                .collection("users")
                                .document(userId)
                                .collection("installation")
                                .document(installationId)
                                .collection("stock")
                                .document(documentSnapshot.documentID)
                                .delete()
                        }
                    }
                }
            
            return subject
                .handleEvents(receiveCancel: { listenerId.remove() })
                .eraseToAnyPublisher()
        },
        send: { message, chat in
            do {
                let subject = PassthroughSubject<Void, Never>()
                let userId = authClient.getAuthenticatedUser()!.id
                let participants = chat.participants.filter { $0.id != userId }
                
                for participant in participants {
                    let userId = participant.id
                    let installationId = installationClient.getCurrentInstallationId()
                    
                    var chatUpdate = chat
                    chatUpdate.messages = [message]
                    
                    let data = try JSONEncoder().encode(chatUpdate)
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                    
                    Task {
                        try await Firestore.firestore()
                            .collection("users")
                            .document(userId)
                            .collection("installation")
                            .document(installationId)
                            .collection("stock")
                            .addDocument(data: json)
                        subject.send(())
                    }
                }
                return subject.eraseToAnyPublisher()
            } catch {
                return Just(()).eraseToAnyPublisher()
            }
        }
    )
}

struct InstallationClient {
    let getCurrentInstallationId: () -> String
}

extension InstallationClient {
    static func mock(_ id: String = "1") -> InstallationClient {
        InstallationClient(getCurrentInstallationId: { id })
    }
}
