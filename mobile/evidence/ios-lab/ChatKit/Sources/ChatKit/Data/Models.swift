import ComposableArchitecture
import Foundation

public typealias MessageID = String
public typealias ChatID = String
public typealias UserID = String
public typealias AuthorID = String

public struct Chat: Identifiable, Equatable, Hashable, Codable {
    public let id: ChatID
    var name: String
    var participants: IdentifiedArrayOf<User>
    var messages: IdentifiedArrayOf<Message>
}

public extension Chat {
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
    
    static func empty() -> Chat {
        Chat(
            id: ChatID(UUID().uuidString),
            name: "",
            participants: [],
            messages: []
        )
    }
}

public struct Message: Identifiable, Equatable, Hashable, Codable {
    public let id: MessageID
    let sender: User
    var content: String
    var preview: Preview?
    var isSent: Bool
    
    public static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension Message {
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

public struct Preview: Equatable, Hashable, Codable {
    let image: URL
    let title: String
}

public struct User: Equatable, Hashable, Identifiable, Codable {
    public let id: UserID
    let name: String
}

public extension User {
    init(name: String, id: UserID = UserID()) {
        self.id = id
        self.name = name
    }
    
    init() {
        self.id = UserID(UUID().uuidString)
        self.name = "empty"
    }
}

public extension User {
    static let vini = User(name: "Vini", id: UserID("HGlLyOjM7vTsX1DZtACoh808SHG2"))
    static let cris = User(name: "Cris", id: UserID("llX9JYSoaxNH77sCmIH6b0xcq6w2"))
    static let lili = User(name: "Lili ❤️‍🔥", id: UserID("0A8F38BA-9484-4889-A74D-46444F3FE52B"))
}


public extension Chat {
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
            Message(content: "Bom dia!", sender: .cris),
            Message.pointfree
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
    
    static let insurances = Chat(
        id: "54CD9181-C419-41E7-ACED-6A9391105DC7",
        name: "Seguros",
        participants: [.vini, .lili],
        messages: [
            Message(content: "Segue a apolice", sender: .lili)
        ]
    )
    
    static let me = Chat(
        id: "44CD9181-C419-41E7-ACED-6A9391105DC7",
        name: "Eu",
        participants: [.vini],
        messages: [
            Message(content: "Bom dia, Eu!", sender: .vini)
        ]
    )
    
    static let mockList = [
        Chat.lili,
        Chat.evidence,
        Chat.recepies,
        Chat.insurances,
        Chat.me
    ]
}


public extension Message {
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