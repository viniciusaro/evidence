import ComposableArchitecture
import Dependencies
import Foundation
import Models

public struct DataClient {
    public let load: (URL) throws -> Data
    public let save: (Data, URL) throws -> Void
}

extension DependencyValues {
    public var dataClient: DataClient {
        get { self[DataClient.self] }
        set { self[DataClient.self] = newValue }
    }
}

extension DataClient: DependencyKey {
    public static let liveValue = DataClient(
        load: { url in try Data(contentsOf: url) },
        save: { data, url in try data.write(to: url) }
    )
    
    public static func mock(_ chats: [Chat]) -> DataClient {
        DataClient(
            load: { _ in try JSONEncoder().encode(chats) },
            save: { _, _ in }
        )
    }
}

extension URL {
    public static func chats(prefix: String) -> URL {
        Self.documentsDirectory.appending(path: prefix + ".chats.json")
    }
}
