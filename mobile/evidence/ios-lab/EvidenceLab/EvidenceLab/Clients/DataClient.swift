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
}

extension URL {
    static let chats = Self.documentsDirectory.appending(path: "chats.json")
}
