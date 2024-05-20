import AuthClient
import Combine
import Dependencies
import FirebaseFirestore
import Models
import StockClient

extension StockClient: DependencyKey {
    public static let liveValue = StockClient(
        consume: {
            @Dependency(\.authClient) var authClient
            @Dependency(\.installationClient) var installationClient
            let subject = PassthroughSubject<ChatUpdate, Never>()
            
            let userId = authClient.getAuthenticatedUser()!.id
            let installationId = installationClient.getCurrentInstallationId()

            let listenerId = Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("installation")
                .document(installationId)
                .collection("stock")
                .order(by: "createdAt")
                .addSnapshotListener { snapshot, error in
                    if let snapshot = snapshot {
                        let chats = try? snapshot.documents.compactMap { document in
                            let data = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                            let chats = try JSONDecoder().decode(ChatUpdate.self, from: data)
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
        send: { chatUpdate in
            @Dependency(\.authClient) var authClient
            @Dependency(\.installationClient) var installationClient
            
            let userId = authClient.getAuthenticatedUser()!.id
            let participants = chatUpdate.participants.filter { $0.id != userId }
            
            for participant in participants {
                let userId = participant.id
                let installationId = installationClient.getCurrentInstallationId()
                
                if
                    let data = try? JSONEncoder().encode(chatUpdate),
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                {
                    _ = try? await Firestore.firestore()
                        .collection("users")
                        .document(userId)
                        .collection("installation")
                        .document(installationId)
                        .collection("stock")
                        .addDocument(data: json)
                }
            }
        }
    )
}
