import Combine
import Foundation

struct StockClient {
    let consume: () -> AnyPublisher<Chat, Never>
}

extension StockClient {
    static let empty = StockClient {
        Empty().eraseToAnyPublisher()
    }
    
    static func mock(_ using: [Chat]) -> StockClient {
        StockClient {
            Timer.publish(every: 5, on: .main, in: .default)
                .autoconnect()
                .map { _ in Chat.random(using: using) }
                .eraseToAnyPublisher()
        }
    }
}
