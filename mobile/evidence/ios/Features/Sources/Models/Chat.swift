import Foundation

public struct Chat: Identifiable, Equatable {
    public let id = UUID()
    public var messages: [Message]
    
    public init(messages: [Message]) {
        self.messages = messages
    }
}

public struct Message: Identifiable, Equatable {
    public let id = UUID()
    public var content: String
    public var recipient: Recipient
    public var likes: Int
}

public struct Recipient: Identifiable, Equatable {
    public let id = UUID()
    public let name: String
}

extension Message {
    public static let error = Message(content: "Error!!", recipient: .vini, likes: 0)
    public static var hi = Message(content: "Hi", recipient: .vini, likes: 0)
    public static var hello = Message(content: "Hello", recipient: .kristem, likes: 0)
    public static var howAreYouDoing = Message(content: "How are you doing?", recipient: .vini, likes: 0)
    public static var link = Message(
        content: "https://www.behance.net/gallery/113252267/UXUI-Case-Study-Hackathon-CCR-2021",
        recipient: .vini,
        likes: 0
    )
    public static var mac = Message(
        content: "https://medium.com/@nqtuan86/clean-mac-storage-for-xcodes-users-5fbb32239aa5",
        recipient: .kristem,
        likes: 10
    )
    
    public static var blind = Message(
        content: "https://www.teamblind.com/",
        recipient: .kristem,
        likes: 10
    )
    
    public static var tabNews = Message(
        content: "https://www.tabnews.com.br",
        recipient: .kristem,
        likes: 10
    )
    
    public static func pr(_ n: Int) -> Message {
        Message(
            content: "https://github.com/viniciusaro/evidence/pull/\(n)",
            recipient: .vini,
            likes: 3
        )
    }
}

extension Recipient {
    public static let vini = Recipient(name: "Vini")
    public static let kristem = Recipient(name: "kris tem")
}
