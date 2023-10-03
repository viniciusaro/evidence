// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EvidenceDependencies",
    platforms: [
        .iOS(.v13), .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "EvidenceDependencies",
            targets: ["EvidenceDependencies"]
        ),
    ],
    dependencies: [
        .package(path: "../Leaf")
    ],
    targets: [
        .target(
            name: "EvidenceDependencies",
            dependencies: ["Leaf"]
        ),
    ]
)
