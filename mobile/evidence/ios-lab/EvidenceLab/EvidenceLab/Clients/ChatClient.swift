import Combine
import Foundation

struct ChatClient {
    let getAll: () -> AnyPublisher<[Chat], Never>
    let new: (String) -> AnyPublisher<Chat, Never>
    let send: (String, String) -> AnyPublisher<Void, Never>
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
                let filemanager = FileManager.default
                let directory = URL.documentsDirectory.appending(path: "chats")
                print("get all from dir: \(directory)")
                
                do {
                    print("trying to get files... \(directory.path(percentEncoded: true))")
                    let files = try filemanager.contentsOfDirectory(atPath: directory.path(percentEncoded: true))
                    print("found files: \(files)")
                    var chats = [Chat]()
                    for file in files {
                        let url = directory.appending(path: file)
                        let data = try Data(contentsOf: url)
                        let chat = try JSONDecoder().decode(Chat.self, from: data)
                        chats.append(chat)
                    }
                    return Just(chats).eraseToAnyPublisher()
                } catch {
                    print("error trying to fetch files: \(error)")
                    return Just([]).eraseToAnyPublisher()
                }
            },
            new: { name in
                let filemanager = FileManager.default
                let chat = Chat(name: name, messages: [])
                let directory = URL.documentsDirectory.appending(path: "chats")
                let url = directory.appending(path: "\(name).json")
                print("New file will be written at: \(url)")
                
                do {
                    try filemanager.createDirectory(at: directory, withIntermediateDirectories: true)
                    let data = try JSONEncoder().encode(chat)
                    try data.write(to: url)
                    return Just(chat).eraseToAnyPublisher()
                } catch {
                    print("error trying to write file: \(error)")
                    return Just(Chat.error).eraseToAnyPublisher()
                }
            },
            send: { content, chatName in
                let url = URL.documentsDirectory.appending(path: "chats/\(chatName).json")
                print("trying to send data to: \(url)")
                do {
                    let data = try Data(contentsOf: url)
                    let chat = try JSONDecoder().decode(Chat.self, from: data)
                    let updated = Chat(
                        id: chat.id,
                        name: chat.name,
                        messages: chat.messages + [Message(content: content)]
                    )
                    let updatedData = try JSONEncoder().encode(updated)
                    try updatedData.write(to: url)
                } catch {
                    print("error sending data: \(error)")
                    return Just(()).eraseToAnyPublisher()
                }
                print("success!")
                return Just(()).eraseToAnyPublisher()
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
