// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChatKit",
    platforms: [
        .iOS(.v17), .macOS(.v14)
    ],
    products: [
        .library(
            name: "ChatKit",
            targets: ["ChatKit"]
        )
    ],
    dependencies: [
        .package(
            url: "git@github.com:pointfreeco/swift-composable-architecture.git",
            from: "1.10.2"
        ),
        .package(path: "../Clients"),
        .package(path: "../Leaf")
    ],
    targets: [
        .target(
            name: "ChatKit",
            dependencies: [
                .product(name: "Clients", package: "Clients"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Leaf", package: "Leaf")
            ]
        ),
        .testTarget(
            name: "ChatKitTests",
            dependencies: [
                "ChatKit"
            ]
        ),
    ]
)
