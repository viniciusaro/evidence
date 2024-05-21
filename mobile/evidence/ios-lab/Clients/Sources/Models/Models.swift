import ComposableArchitecture
import Foundation

public typealias MessageID = String
public typealias ChatID = String
public typealias UserID = String
public typealias AuthorID = String

public struct ChatUpdate: Codable {
    public let chatId: ChatID
    public let name: String
    public var message: Message
    public let participants: IdentifiedArrayOf<User>
    public let plugins: IdentifiedArrayOf<Plugin>
    public let createdAt: Date
    
    public init(
        chatId: ChatID,
        name: String,
        message: Message,
        participants: IdentifiedArrayOf<User>,
        plugins: IdentifiedArrayOf<Plugin>,
        createdAt: Date = .now
    ) {
        self.chatId = chatId
        self.name = name
        self.message = message
        self.participants = participants
        self.plugins = plugins
        self.createdAt = createdAt
    }
}

public struct Chat: Identifiable, Equatable, Hashable, Codable {
    public let id: ChatID
    public var name: String
    public var participants: IdentifiedArrayOf<User>
    public var messages: IdentifiedArrayOf<Message>
    public var plugins: IdentifiedArrayOf<Plugin> = []
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

public extension ChatUpdate {
    static func random(using chats: [Chat]) -> ChatUpdate {
        let chat = Chat.random(using: chats)
        
        return ChatUpdate(
            chatId: chat.id,
            name: chat.name,
            message: chat.messages[0],
            participants: chat.participants,
            plugins: chat.plugins,
            createdAt: .now
        )
    }
    
    static func from(chat: Chat, message: Message) -> ChatUpdate {
        ChatUpdate(
            chatId: chat.id,
            name: chat.name,
            message: message,
            participants: chat.participants,
            plugins: chat.plugins,
            createdAt: .now
        )
    }
    
    static func from(update: ChatUpdate, message: Message) -> ChatUpdate {
        ChatUpdate(
            chatId: update.chatId,
            name: update.name,
            message: message,
            participants: update.participants,
            plugins: update.plugins,
            createdAt: .now
        )
    }
    
    func toChat() -> Chat {
        Chat(id: chatId, name: name, participants: participants, messages: IdentifiedArray(uniqueElements: [message]))
    }
}

public struct Message: Identifiable, Equatable, Hashable, Codable {
    public let id: MessageID
    public let sender: User
    public var content: String
    public var preview: Preview?
    public var isSent: Bool
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
    public let image: URL
    public let title: String
    
    public init(image: URL, title: String) {
        self.image = image
        self.title = title
    }
}

public struct User: Equatable, Hashable, Identifiable, Codable {
    public let id: UserID
    public let name: String
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct Plugin: Identifiable, Equatable, Hashable, Codable {
    public let id: ID
    public let user: User
    public let icon: String
    public let commands: [Command]
    
    public var name: String {
        id.rawValue.capitalized
    }
    
    public enum ID: String, Codable {
        case openAI
        case ping
        case split
    }
    
    public struct Command: Identifiable, Equatable, Hashable, Codable {
        public let name: String
        public let description: String
        
        public var id: String {
            name + description
        }
        
        public func matches(update: ChatUpdate) -> Bool {
            update.message.content.starts(with: "/\(name)")
        }
    }
    
    public static let values: IdentifiedArrayOf<Plugin> = [
        .openAI,
        .ping,
        .split
    ]
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
    static let lili = User(name: "Lili ❤️‍🔥", id: UserID("2qxe6aoTcwcLmYBrj96lsl1tGCg2"))
    static let openAI = User(name: "🙇 OpenAI ", id: UserID("OpenAI"))
    static let ping = User(name: "🌬️ Ping ", id: UserID("Ping"))
    static let split = User(name: "💰 Split", id: UserID("Split"))
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
            Message(content: "Oieeee", sender: .lili),
        ],
        plugins: [
            .openAI,
            .ping
        ]
    )
    
    static let evidence = Chat(
        id: "EBEE82D9-F00A-4372-A14D-34E68BFB17E5",
        name: "Evidence",
        participants: [.vini, .cris],
        messages: [
            Message(content: "Bom dia!", sender: .cris),
            Message.pointfree,
            Message(content: "https://www.pointfree.co/episodes/ep274-shared-state-user-defaults-part-2", sender: .vini),
            Message(content: "Bom dia!", sender: .vini),
            Message(content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", sender: .vini)
        ],
        plugins: [
            .openAI,
            .ping,
            .split
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
    
    static let ipsum = Message(
        id: MessageID(UUID().uuidString),
        sender: .vini,
        content: "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum",
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

public extension Plugin {
    static let openAI = Plugin(
        id: .openAI,
        user: .openAI,
        icon: "circle.hexagongrid.circle",
        commands: [
            Command(name: "about", description: "lorem ipsum openai"),
            Command(name: "chat", description: "lorem ipsum openai")
        ]
    )
    
    static let ping = Plugin(
        id: .ping,
        user: .ping,
        icon: "lasso",
        commands: [
            Command(name: "about", description: "lorem ipsum ping"),
            Command(name: "ping", description: "lorem ipsum ping"),
        ]
    )
    
    static let split = Plugin(
        id: .split,
        user: .split,
        icon: "homepod",
        commands: [
            Command(name: "about", description: "lorem ipsum split"),
            Command(name: "despesa", description: "lorem ipsum split"),
            Command(name: "totais", description: "lorem ipsum split")
        ]
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
