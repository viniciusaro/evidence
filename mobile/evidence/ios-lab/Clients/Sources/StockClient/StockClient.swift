import Combine
import Dependencies
import Foundation
import Models

public struct StockClient {
    public let consume: () -> AnyPublisher<ChatUpdate, Never>
    public let send: (ChatUpdate) async -> Void
    
    public init(
        consume: @escaping () -> AnyPublisher<ChatUpdate, Never>,
        send: @escaping (ChatUpdate) async -> Void
    ) {
        self.consume = consume
        self.send = send
    }
}

extension StockClient: TestDependencyKey {
    public static let testValue = StockClient.empty
    public static let previewValue = StockClient.mock(Chat.mockList)
}

extension DependencyValues {
    public var stockClient: StockClient {
        get { self[StockClient.self] }
        set { self[StockClient.self] = newValue }
    }
}

extension StockClient {
    public static let empty = StockClient(
        consume: { Empty().eraseToAnyPublisher() },
        send: { _ in }
    )
    
    public static func mock(_ using: [Chat], interval: Double = 5) -> StockClient {
        StockClient(
            consume: {
                Timer.publish(every: interval, on: .main, in: .default)
                    .autoconnect()
                    .map { _ in ChatUpdate.random(using: using) }
                    .eraseToAnyPublisher()
            },
            send: { _ in }
        )
    }
}
