// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EvidenceDependencies",
    platforms: [
        .iOS(.v17), .macOS(.v12)
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
                .product(name: "Login", package: "Features"),
            ]
        ),
    ]
)
