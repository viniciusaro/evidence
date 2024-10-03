import Combine
import Dependencies
import UIKit

public struct Asset: Equatable {
    public let id: String
    public let source: AnyObject
    
    public init(id: String, source: AnyObject) {
        self.id = id
        self.source = source
    }
    
    public static func == (lhs: Asset, rhs: Asset) -> Bool {
        lhs.id == rhs.id
    }
}

public struct AssetImage: Equatable, Identifiable {
    public let id: String
    public let image: UIImage
    
    public init(id: String, image: UIImage) {
        self.id = id
        self.image = image
    }
}

public struct PhotoClient {
    public let assets: () -> AnyPublisher<[Asset], Never>
    public let data: (Asset) -> AnyPublisher<AssetImage, Never>
    
    public init(
        assets: @escaping () -> AnyPublisher<[Asset], Never>,
        data: @escaping (Asset) -> AnyPublisher<AssetImage, Never>
    ) {
        self.assets = assets
        self.data = data
    }
}

extension PhotoClient: TestDependencyKey {
    public static let testValue = PhotoClient.system
    public static let previewValue = PhotoClient.system
}

extension DependencyValues {
    public var photoClient: PhotoClient {
        get { self[PhotoClient.self] }
        set { self[PhotoClient.self] = newValue }
    }
}
