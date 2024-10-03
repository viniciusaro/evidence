import Combine
import UIKit

fileprivate class Source {}

extension PhotoClient {
    public static let empty = PhotoClient(
        assets: { Empty().eraseToAnyPublisher() },
        data: { _ in Empty().eraseToAnyPublisher() }
    )
    
    public static let system = PhotoClient(
        assets: {
            Just([
                Asset(id: "photo", source: Source()),
                Asset(id: "xmark", source: Source()),
                Asset(id: "gearshape", source: Source()),
                Asset(id: "eraser", source: Source()),
                Asset(id: "scribble", source: Source()),
                Asset(id: "pencil.circle.fill", source: Source()),
                Asset(id: "square.and.pencil.circle", source: Source()),
                Asset(id: "trash.slash.circle.fill", source: Source()),
                Asset(id: "folder.fill.badge.person.crop", source: Source()),
                Asset(id: "internaldrive", source: Source()),
                Asset(id: "externaldrive.connected.to.line.below.fill", source: Source()),
                Asset(id: "list.bullet.rectangle.portrait", source: Source()),
                Asset(id: "apple.terminal.on.rectangle", source: Source()),
                Asset(id: "widget.medium.badge.plus", source: Source()),
                Asset(id: "arrowshape.zigzag.right.fill", source: Source()),
            ]
            ).eraseToAnyPublisher()
        },
        data: { asset in
            return Just(AssetImage(id: asset.id, image: UIImage(systemName: asset.id)!))
                .eraseToAnyPublisher()
        }
    )
}
