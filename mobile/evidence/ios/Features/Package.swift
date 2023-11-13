// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .iOS(.v16), .macOS(.v13)
    ],
    products: [
        .library(
            name: "Chat",
            targets: ["Chat"]),
        .library(
            name: "Models",
            targets: ["Models"]),
        .library(
            name: "TestHelper",
            targets: ["TestHelper"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-custom-dump",
            from: "1.1.1"
        )
    ],
    targets: [
        .target(
            name: "Chat",
            dependencies: [
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "ChatTests",
            dependencies: [
                "Chat", "TestHelper"
            ]
        ),
        .target(
            name: "Models"
        ),
        .target(
            name: "TestHelper",
            dependencies: [
                .product(name: "CustomDump", package: "swift-custom-dump"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
    ]
)
