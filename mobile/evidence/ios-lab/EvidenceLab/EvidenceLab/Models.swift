import Foundation

typealias MessageID = UUID
typealias ChatID = UUID
typealias UserID = UUID

struct Chat: Identifiable, Equatable, Hashable, Codable {
    let id: ChatID
    let name: String
    let messages: [Message]
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
    let content: String
    let preview: Preview?
}

extension Message {
    init(content: String) {
        self.id = MessageID()
        self.content = content
        self.preview = nil
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
