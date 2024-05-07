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
            targets: ["ChatKit"]),
    ],
    dependencies: [
        .package(
            url: "git@github.com:pointfreeco/swift-composable-architecture.git",
            branch: "shared-state-beta"
        ),
        .package(
            url: "git@github.com:firebase/firebase-ios-sdk.git",
            from: "10.24.0"
        ),
        .package(path: "../Clients")
    ],
    targets: [
        .target(
            name: "ChatKit",
            dependencies: [
                .product(name: "AuthClient", package: "Clients"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        )
    ]
)
