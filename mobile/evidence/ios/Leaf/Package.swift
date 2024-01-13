// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Leaf",
    platforms: [
        .iOS(.v16), .macOS(.v12)
    ],
    products: [
        .library(
            name: "Leaf",
            targets: ["Leaf"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.12.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "Leaf",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            resources: [
                .process("Components/Fonts")
                ]
        ),
        .testTarget(
            name: "LeafTests",
            dependencies: [
                "Leaf",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
    ]
)
