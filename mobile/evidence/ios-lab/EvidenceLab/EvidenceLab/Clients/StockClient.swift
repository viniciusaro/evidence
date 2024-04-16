import Combine
import FirebaseFirestore
import Foundation

struct StockClient {
    let consume: () -> AnyPublisher<Chat, Never>
}

extension StockClient {
    static let empty = StockClient {
        Empty().eraseToAnyPublisher()
    }
    
    static func mock(_ using: [Chat]) -> StockClient {
        StockClient {
            Timer.publish(every: 5, on: .main, in: .default)
                .autoconnect()
                .map { _ in Chat.random(using: using) }
                .eraseToAnyPublisher()
        }
    }
    
    static let live = StockClient {
        let subject = PassthroughSubject<Chat, Never>()
        let listenerId = Firestore.firestore()
            .collection("users")
            .document("teste")
            .collection("installations")
            .document("1")
            .collection("stock")
            .addSnapshotListener { snapshot, error in
                if let snapshot = snapshot {
                    let chats = try? snapshot.documents.compactMap { document in
                        let data = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                        let chats = try JSONDecoder().decode(Chat.self, from: data)
                        return chats
                    }
                    chats?.forEach(subject.send)
                }
            }
        
        return subject.eraseToAnyPublisher()
    }
}

struct InstallationClient {
    let getCurrentInstallationId: () -> String
}

extension InstallationClient {
    static func mock(_ id: String = "1") -> InstallationClient {
        InstallationClient(getCurrentInstallationId: { id })
    }
}
