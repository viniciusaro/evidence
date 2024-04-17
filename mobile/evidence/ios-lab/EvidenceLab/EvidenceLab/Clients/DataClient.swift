import Foundation

struct DataClient {
    let load: (URL) throws -> Data
    let save: (Data, URL) throws -> Void
}

extension DataClient {
    static let live = DataClient(
        load: { url in try Data(contentsOf: url) },
        save: { data, url in try data.write(to: url) }
    )
    
    static func mock(_ chats: [Chat]) -> DataClient {
        DataClient(
            load: { _ in try JSONEncoder().encode(chats) },
            save: { _, _ in }
        )
    }
}

extension URL {
    static let chats = Self.documentsDirectory.appending(path: "chats.json")
    static let state = Self.documentsDirectory.appending(path: "state.json")
}
