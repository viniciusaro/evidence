import Combine
import Dependencies
import SwiftUI

struct LeafAsyncImageClient {
    var load: (URL) -> AnyPublisher<Image, Error>
}

struct LeafAsyncImageClientKey: DependencyKey {
    static let liveValue = LeafAsyncImageClient.live
    static let previewValue = LeafAsyncImageClient.preview
    static let testValue = LeafAsyncImageClient.preview
}

extension DependencyValues {
    var leafAsyncImageClient: LeafAsyncImageClient {
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
    static let preview = LeafAsyncImageClient.system("checkmark.circle")
    
    static func system(_ name: String) -> LeafAsyncImageClient {
        LeafAsyncImageClient { _ in
            Just(Image(systemName: name))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    static let neverLoads = LeafAsyncImageClient { url in
        Empty(completeImmediately: false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static let error = LeafAsyncImageClient { url in
        Fail(error: NSError(domain: "LeafError", code: -1))
            .eraseToAnyPublisher()
    }
}

