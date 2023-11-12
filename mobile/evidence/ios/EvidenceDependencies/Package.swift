// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EvidenceDependencies",
    platforms: [
        .iOS(.v16), .macOS(.v12)
    ],
    products: [
        .library(
            name: "EvidenceDependencies",
            targets: ["EvidenceDependencies"]
        ),
    ],
    dependencies: [
        .package(path: "../Leaf"),
        .package(path: "../Features"),
    ],
    targets: [
        .target(
            name: "EvidenceDependencies",
            dependencies: [
                "Leaf",
                .product(name: "Chat", package: "Features"),
                .product(name: "Profile", package: "Features"),
            ]
        ),
    ]
)
