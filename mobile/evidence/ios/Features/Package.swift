// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .iOS(.v16), .macOS(.v12)
    ],
    products: [
        .library(
            name: "Chat",
            targets: ["Chat"]),
        .library(
            name: "Models",
            targets: ["Models"]),
    ],
    targets: [
        .target(
            name: "Chat",
            dependencies: ["Models"]),
        .testTarget(
            name: "ChatTests",
            dependencies: ["Chat", "Models"]),
        .target(
            name: "Models"),
    ]
)
