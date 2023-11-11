//
//  LeafTagTests.swift
//  
//
//  Created by Cris Messias on 24/10/23.
//
import SnapshotTesting
import SwiftUI
import XCTest

@testable import Leaf

final class LeafTagTests: XCTestCase {
    func testOpenTag() {
        let tag = LeafTag("open", status: .open)
        let controller = UIHostingController(rootView: tag)
        let darkTrait  = UITraitCollection(userInterfaceStyle: .dark)
        
        assertSnapshot(matching: controller, as: .image(on: .iPhone8))
        assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
    }
    func testAcceptedTag() {
        let tag = LeafTag("accepted", status: .accepted)
        let controller = UIHostingController(rootView: tag)
        let darkTrait  = UITraitCollection(userInterfaceStyle: .dark)
        
        assertSnapshot(matching: controller, as: .image(on: .iPhone8))
        assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
    }
    func testRejectedTag() {
        let tag = LeafTag("rejected", status: .rejected)
        let controller = UIHostingController(rootView: tag)
        let darkTrait  = UITraitCollection(userInterfaceStyle: .dark)
        
        assertSnapshot(matching: controller, as: .image(on: .iPhone8))
        assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
    }
    func testClosedTag() {
        let tag = LeafTag("closed", status: .closed)
        let controller = UIHostingController(rootView: tag)
        let darkTrait  = UITraitCollection(userInterfaceStyle: .dark)
        
        assertSnapshot(matching: controller, as: .image(on: .iPhone8))
        assertSnapshot(matching: controller, as: .image(on: .iPhone8, traits: darkTrait))
    }
}
