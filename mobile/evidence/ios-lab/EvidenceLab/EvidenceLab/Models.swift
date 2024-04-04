import Foundation

typealias MessageID = UUID
typealias ChatID = UUID
typealias UserID = UUID

struct Chat: Identifiable, Equatable, Hashable {
    let id = ChatID()
    let name: String
    let messages: [Message]
}

struct Message: Identifiable, Equatable, Hashable {
    let id = MessageID()
    let content: String
    let preview: Preview? = nil
}

struct Preview: Equatable, Hashable {
    let image: URL
    let title: String
}

struct User: Equatable, Hashable, Identifiable {
    let id = UserID()
    let name: String
}

let chatsUpdate = [
    Chat(
        name: "Lili ❤️‍🔥",
        messages: [
            Message(content: "Oi amor"),
            Message(content:
                "https://medium.com/@nqtuan86/clean-mac-storage-for-xcodes-users-5fbb32239aa5"
            ),
        ]
    ),
    Chat(
        name: "Grupo da Família",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Nossas Receitas",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Infinito particular",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Snow dos brothers 2024",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
]

extension User {
    static let vini = User(name: "Vini")
    static let cris = User(name: "Cris")
}
