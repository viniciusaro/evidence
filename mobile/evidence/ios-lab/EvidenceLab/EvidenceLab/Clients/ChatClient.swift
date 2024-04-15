import Combine
import Foundation

struct ChatClient {
    let getAll: () -> AnyPublisher<[Chat], Never>
    let new: (String) -> AnyPublisher<Chat, Never>
    let send: (Message, ChatID) -> AnyPublisher<Void, Never>
}

extension ChatClient {
    static let mock = ChatClient(
        getAll: { Just(Chat.mockList).eraseToAnyPublisher() },
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
                .eraseToAnyPublisher()
            }
        )
    }
}
