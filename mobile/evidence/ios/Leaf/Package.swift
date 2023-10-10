// swift-tools-version: 5.8
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
        .package(url: "https://github.com/lorenzofiamingo/swiftui-cached-async-image", from: "2.1.1"),
    ],
    targets: [
        .target(
            name: "Leaf",
            dependencies: [
                .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image")
            ]
        ),
        .testTarget(
            name: "LeafTests",
            dependencies: ["Leaf"]
        ),
    ]
)
