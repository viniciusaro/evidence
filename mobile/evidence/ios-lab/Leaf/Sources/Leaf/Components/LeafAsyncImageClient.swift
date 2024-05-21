import Combine
import Dependencies
import SwiftUI

public struct LeafAsyncImageClient {
    var load: (URL) -> AnyPublisher<Image, Error>
}

public struct LeafAsyncImageClientKey: DependencyKey {
    public static let liveValue = LeafAsyncImageClient.live
    public static let testValue = LeafAsyncImageClient.system("checkmark.circle")
}

extension DependencyValues {
    public var leafAsyncImageClient: LeafAsyncImageClient {
        get { self[LeafAsyncImageClientKey.self] }
        set { self[LeafAsyncImageClientKey.self] = newValue }
    }
}

extension LeafAsyncImageClient {
    static let live = LeafAsyncImageClient { url in
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
            .tryMap() { UIImage(data: $0.data) ?? UIImage() }
            .map { Image(uiImage: $0) }
            .eraseToAnyPublisher()
    }
}

extension LeafAsyncImageClient {
    public static func system(_ name: String) -> LeafAsyncImageClient {
        LeafAsyncImageClient { _ in
            Just(Image(systemName: name))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    public static let neverLoads = LeafAsyncImageClient { url in
        Empty(completeImmediately: false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public static let error = LeafAsyncImageClient { url in
        Fail(error: NSError(domain: "LeafError", code: -1))
            .eraseToAnyPublisher()
    }
}

