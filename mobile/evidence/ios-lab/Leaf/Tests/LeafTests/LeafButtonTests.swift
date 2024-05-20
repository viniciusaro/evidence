import SnapshotTesting
import SwiftUI
import XCTest

@testable import Leaf

final class LeafButtonTests: XCTestCase {
    func testStylePrimary() {
        let sut = LeafThemeView {
            Button("Evidence") {}.buttonStyle(LeafPrimaryButtonStyle())
        }
        let controller = UIHostingController(rootView: sut)
        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        
        assertSnapshot(matching: controller, as: .image(on: .iPhone8))
        assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
    }
}
