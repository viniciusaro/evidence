import XCTest
import SwiftUI
import SnapshotTesting

@testable import Leaf

final class LeafButtonTests: XCTestCase {
    func testStylePrimary() throws {
        let sut = LeafThemeView {
            Button("Evidence") {}.buttonStyle(LeafPrimaryButtonStyle())
        }
        let controller = UIHostingController(rootView: sut)
        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        
        assertSnapshot(matching: controller, as: .image(on: .iPhone8))
        assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
    }
}
