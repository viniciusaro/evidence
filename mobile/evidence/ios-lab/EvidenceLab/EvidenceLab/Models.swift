import Foundation

typealias MessageID = UUID
typealias ChatID = UUID

struct Chat: Identifiable, Equatable, Hashable {
    let id = ChatID()
    let name: String
    var messages: [Message]
}

struct Message: Identifiable, Equatable, Hashable {
    let id = MessageID()
    let content: String
    var preview: Preview? = nil
}

struct Preview: Equatable, Hashable {
    let image: URL
    let title: String
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
