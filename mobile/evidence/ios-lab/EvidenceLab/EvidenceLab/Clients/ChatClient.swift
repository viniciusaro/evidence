import Foundation
import Combine

struct ChatClient {
    let getAll: () -> AnyPublisher<[Chat], Never>
    let send: (String) -> AnyPublisher<Void, Never>
}

extension ChatClient {
    static let mock = ChatClient(
        getAll: { Just(Chat.mock).eraseToAnyPublisher() },
        send: { message in Just(()).eraseToAnyPublisher() }
    )
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
}
