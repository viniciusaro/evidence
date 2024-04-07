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
