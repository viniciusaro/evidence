// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Leaf",
    platforms: [
        .iOS(.v13), .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "Leaf",
            targets: ["Leaf"]),
    ],
    targets: [
        .target(
            name: "Leaf",
            dependencies: []),
        .testTarget(
            name: "LeafTests",
            dependencies: ["Leaf"]),
    ]
)
