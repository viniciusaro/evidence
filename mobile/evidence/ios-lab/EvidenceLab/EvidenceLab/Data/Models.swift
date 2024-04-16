import Foundation

typealias MessageID = UUID
typealias ChatID = UUID
typealias UserID = String
typealias AuthorID = String

struct Chat: Identifiable, Equatable, Hashable, Codable {
    let id: ChatID
    var messages: [Message]
    let name: String
    var participants: [User]
}

extension Chat {
    init(name: String, participants: [User], messages: [Message]) {
        self.id = ChatID()
        self.name = name
        self.messages = messages
        self.participants = participants
    }
}

struct Message: Identifiable, Equatable, Hashable, Codable {
    let id: MessageID
    let sender: User
    var content: String
    var preview: Preview?
    var isSent: Bool
}

extension Message {
    init(content: String, sender: User) {
        self.id = MessageID()
        self.content = content
        self.preview = nil
        self.isSent = false
        self.sender = sender
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
    init(name: String, id: UserID = UserID()) {
        self.id = id
        self.name = name
    }
    
    init() {
        self.id = UserID()
        self.name = "empty"
    }
}

extension User {
    static let vini = User(name: "Vini", id: UserID("vini"))
    static let cris = User(name: "Cris", id: UserID("cris"))
    static let lili = User(name: "Lili ❤️‍🔥", id: UserID("lili"))
}


extension Chat {
    static let lili = Chat(
        name: "Lili ❤️‍🔥",
        participants: [.vini, .lili],
        messages: [
            Message(content: "Oi amor", sender: .lili),
            Message(
                content: "https://medium.com/@nqtuan86/clean-mac-storage-for-xcodes-users-5fbb32239aa5",
                sender: .vini
            ),
        ]
    )
    
    static let evidence = Chat(
        name: "Evidence",
        participants: [.vini, .cris],
        messages: [
            Message(content: "Bom dia!", sender: .cris)
        ]
    )
    
    static let recepies = Chat(
        name: "Nossas Receitas",
        participants: [.vini, .lili],
        messages: [
            Message(content: "Bom dia!", sender: .vini)
        ]
    )
    
    static let mockList = [
        Chat.lili,
        Chat.evidence,
        Chat.recepies,
    ]
}


extension Message {
    static let hi = Message(
        id: UUID(),
        sender: .vini,
        content: "Olá",
        preview: nil,
        isSent: false
    )
    
    static let pointfree = Message(
        id: UUID(),
        sender: .cris,
        content: "https://www.pointfree.co/episodes/ep274-shared-state-user-defaults-part-2",
        preview: nil,
        isSent: false
    )
}
