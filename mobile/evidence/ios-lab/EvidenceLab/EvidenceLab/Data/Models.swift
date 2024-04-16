import Foundation
import OrderedCollections

typealias MessageID = String
typealias ChatID = String
typealias UserID = String
typealias AuthorID = String

struct Chat: Identifiable, Equatable, Hashable, Codable {
    let id: ChatID
    let name: String
    var participants: [User]
    var messages: OrderedSet<Message>
}

extension Chat {
    static func random(using chats: [Chat]) -> Chat {
        let newChat = Chat(
            id: ChatID(UUID().uuidString),
            name: randomString(length: 10),
            participants: [randomUser()],
            messages: []
        )
        let chat = chats.randomElement() ?? newChat
        
        return Chat(
            id: chat.id,
            name: chat.name,
            participants: [randomUser()],
            messages: [Message.random()]
        )
    }
}

struct Message: Identifiable, Equatable, Hashable, Codable {
    let id: MessageID
    let sender: User
    var content: String
    var preview: Preview?
    var isSent: Bool
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Message {
    init(content: String, sender: User) {
        self.id = MessageID(UUID().uuidString)
        self.content = content
        self.preview = nil
        self.isSent = false
        self.sender = sender
    }
    
    static func random() -> Message {
        Message(
            id: MessageID(UUID().uuidString),
            sender: randomUser(),
            content: randomString(length: 30),
            isSent: true
        )
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
        self.id = UserID(UUID().uuidString)
        self.name = "empty"
    }
}

extension User {
    static let vini = User(name: "Vini", id: UserID("1A1BF872-73A0-4E12-9DD3-090961017CEE"))
    static let cris = User(name: "Cris", id: UserID("5101FEA4-744D-4D99-B71D-B3E53B2EFEA8"))
    static let lili = User(name: "Lili ❤️‍🔥", id: UserID("0A8F38BA-9484-4889-A74D-46444F3FE52B"))
}


extension Chat {
    static let lili = Chat(
        id: "5CA52B4E-4BD9-4776-9D4C-1A0E9C76B062",
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
        id: "EBEE82D9-F00A-4372-A14D-34E68BFB17E5",
        name: "Evidence",
        participants: [.vini, .cris],
        messages: [
            Message(content: "Bom dia!", sender: .cris)
        ]
    )
    
    static let recepies = Chat(
        id: "34CD9181-C419-41E7-ACED-6A9391105DC7",
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
        id: MessageID(UUID().uuidString),
        sender: .vini,
        content: "Olá",
        preview: nil,
        isSent: false
    )
    
    static let pointfree = Message(
        id: MessageID(UUID().uuidString),
        sender: .cris,
        content: "https://www.pointfree.co/episodes/ep274-shared-state-user-defaults-part-2",
        preview: nil,
        isSent: false
    )
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

func randomUser() -> User {
    let users = [User.vini, User.cris, User.lili]
    return users.randomElement() ?? .vini
}
