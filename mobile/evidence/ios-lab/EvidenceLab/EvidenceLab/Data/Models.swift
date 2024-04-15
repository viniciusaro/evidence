import Foundation

typealias MessageID = UUID
typealias ChatID = UUID
typealias UserID = UUID

struct Chat: Identifiable, Equatable, Hashable, Codable {
    let id: ChatID
    let name: String
    var messages: [Message]
}

extension Chat {
    init(name: String, messages: [Message]) {
        self.id = ChatID()
        self.name = name
        self.messages = messages
    }
}

struct Message: Identifiable, Equatable, Hashable, Codable {
    let id: MessageID
    var content: String
    var preview: Preview?
    var isSent: Bool
}

extension Message {
    init(content: String) {
        self.id = MessageID()
        self.content = content
        self.preview = nil
        self.isSent = false
    }
}

struct Preview: Equatable, Hashable, Codable {
    let image: URL
    let title: String
}

struct User: Equatable, Hashable, Identifiable, Codable {
    let id: UserID
    let name: String
}

extension User {
    init(name: String) {
        self.id = UserID()
        self.name = name
    }
}

extension Chat {
    static let lili = Chat(
        name: "Lili ❤️‍🔥",
        messages: [
            Message(content: "Oi amor"),
            Message(content:
                        "https://medium.com/@nqtuan86/clean-mac-storage-for-xcodes-users-5fbb32239aa5"
                   ),
        ]
    )
    
    static let family = Chat(
        name: "Grupo da Família",
        messages: [
            Message(content: "Bom dia!")
        ]
    )
    
    static let recepies = Chat(
        name: "Nossas Receitas",
        messages: [
            Message(content: "Bom dia!")
        ]
    )
    
    static let mockList = [
        Chat.lili,
        Chat.family,
        Chat.recepies,
    ]
    
    static let error = Chat(name: "error", messages: [])
}


extension Message {
    static let hi = Message(
        id: UUID(),
        content: "Olá",
        preview: nil,
        isSent: false
    )
    
    static let pointfree = Message(
        id: UUID(),
        content: "https://www.pointfree.co/episodes/ep274-shared-state-user-defaults-part-2",
        preview: nil,
        isSent: false
    )
}
