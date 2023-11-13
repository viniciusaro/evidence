import Combine
import Dependencies
import Foundation

public struct URLPreviewClient {
    public var get: (URL) -> AnyPublisher<(image: URL, title: String)?, Never>
}

extension URLPreviewClient: DependencyKey {
    public static let liveValue = URLPreviewClient.live
}

extension DependencyValues {
    var urlPreviewClient: URLPreviewClient {
        get { self[URLPreviewClient.self] }
        set { self[URLPreviewClient.self] = newValue }
    }
}

public extension URLPreviewClient {
    static let live = URLPreviewClient { url in
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.allHTTPHeaderFields = [
            "cookie": "ilo0=false",
        ]
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in data }
            .map { String(decoding: $0, as: UTF8.self) }
            .map { string in
                guard
                    let imageUrlString = string.findMetaProperty("image"),
                    let image = URL(string: String(imageUrlString)),
                    let title = string.findMetaProperty("title") else {
                    return nil
                }
                return (image, title)
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

public extension URLPreviewClient {
    static let mock = URLPreviewClient { _ in
        Just((
            image: URL(string: "https://www.iclarified.com/images/news/91219/437004/437004-1280.avif")!,
            title: "It is not evident, it needs discussion"
        )).eraseToAnyPublisher()
    }
}

extension String {
    func findMetaProperty(_ property: String) -> String? {
        guard
            let regex = try? Regex("property=\"og:\(property)\" content=\"(.*?)\""),
            let urlStringMatch = try? regex.firstMatch(in: self),
            let urlString = urlStringMatch.output[1].substring else {
                return nil
            }
        return String(urlString)
    }
}
