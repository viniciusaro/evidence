import Dependencies
import SnapshotTesting
import SwiftUI
import XCTest

@testable import Leaf

final class LeafAvatarTests: XCTestCase {
    func testLoading() {
        withDependencies {
            $0.leafAsyncImageClient = .neverLoads
        } operation: {
            let sut = LeafThemeView {
                LeafAvatar(url: URL.documentsDirectory)
            }
            let controller = UIHostingController(rootView: sut)
            let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
            
            assertSnapshot(matching: controller, as: .image(on: .iPhone8))
            assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
        }
    }
    
    func testLoaded() {
        withDependencies {
            $0.leafAsyncImageClient = .system("checkmark.circle.fill")
        } operation: {
            let sut = LeafThemeView {
                LeafAvatar(url: URL.documentsDirectory)
            }
            let controller = UIHostingController(rootView: sut)
            let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
            
            assertSnapshot(matching: controller, as: .image(on: .iPhone8))
            assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
        }
    }
    
    func testError() {
        withDependencies {
            $0.leafAsyncImageClient = .error
        } operation: {
            let sut = LeafThemeView {
                LeafAvatar(url: URL.documentsDirectory)
            }
            let controller = UIHostingController(rootView: sut)
            let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
            
            assertSnapshot(matching: controller, as: .image(on: .iPhone8))
            assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
        }
    }
}
