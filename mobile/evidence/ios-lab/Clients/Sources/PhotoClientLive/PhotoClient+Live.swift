import Combine
import Dependencies
import PhotoClient
import Photos
import UIKit

extension PhotoClient: DependencyKey {
    public static var liveValue: PhotoClient = PhotoClient.live
}

extension PhotoClient {
    class Observer: NSObject, PHPhotoLibraryChangeObserver {
        let subject: CurrentValueSubject<[Asset], Never>
        
        init(subject: CurrentValueSubject<[Asset], Never>) {
            self.subject = subject
        }
        
        func photoLibraryDidChange(_ change: PHChange) {
            let result = PHAsset.fetchAssets(with: nil)
            var assets = [Asset]()
            
            for i in 0..<result.count {
                let asset = result.object(at: i)
                assets.append(Asset(id: asset.localIdentifier, source: asset))
            }
            
            subject.send(assets)
        }
    }
    
    public static var live = PhotoClient(
        assets: {
            let subject = CurrentValueSubject<[Asset], Never>([])
            let observer = Observer(subject: subject)
            PHPhotoLibrary.shared().register(observer)
            
            let result = PHAsset.fetchAssets(with: nil)
            var assets = [Asset]()
            
            for i in 0..<result.count {
                let asset = result.object(at: i)
                if asset.playbackStyle == PHAsset.PlaybackStyle.image {
                    assets.append(Asset(id: asset.localIdentifier, source: asset))
                }
            }
            
            subject.send(assets)
            return subject
                .handleEvents(receiveCancel: { PHPhotoLibrary.shared().unregisterChangeObserver(observer) })
                .eraseToAnyPublisher()
        },
        data: { asset in
            let subject = PassthroughSubject<AssetImage, Never>()
            
            PHImageManager.default().requestImage(
                for: asset.source as! PHAsset,
                targetSize: CGSize(width: 100, height: 100),
                contentMode: PHImageContentMode.aspectFill,
                options: nil
            ) { image, error in
                    if let image = image {
                        subject.send(AssetImage(id: asset.id, image: image))
                    } else {
                        print("error")
                    }
                }
            
            return subject
                .eraseToAnyPublisher()
        }
    )
}
