import Combine
import Foundation

struct ChatClient {
    let getAll: () -> AnyPublisher<[Chat], Never>
    let new: (String) -> AnyPublisher<Chat, Never>
    let send: (Message, ChatID) -> AnyPublisher<Void, Never>
}

extension ChatClient {
    static let mock = ChatClient(
        getAll: { Just(Chat.mock).eraseToAnyPublisher() },
        new: { name in Just(Chat(name: name, messages: [])).eraseToAnyPublisher() },
        send: { message, chat in Just(()).eraseToAnyPublisher() }
    )
    
    static var filesystem: ChatClient {
        ChatClient(
            getAll: {
                return chatDocumentClient.getAll()
            },
            new: { name in
                let chat = Chat(name: name, messages: [])
                return chatDocumentClient.create(chat)
            },
            send: { message, chatId in
                return chatDocumentClient.get(chatId).flatMap { chat in
                    let updated = Chat(
                        id: chat.id,
                        name: chat.name,
                        messages: chat.messages + [message]
                    )
                    return chatDocumentClient.update(updated)
                }
                .delay(for: .seconds(5), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
            }
        )
    }
}

extension Chat {
    static let mock = [
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
    
    static let error = Chat(name: "error", messages: [])
}
