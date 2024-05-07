// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Clients",
    platforms: [
        .iOS(.v17), .macOS(.v14)
    ],
    products: [
        .library(
            name: "AuthClient",
            targets: ["AuthClient"]
        ),
        .library(
            name: "AuthClientLive",
            targets: ["AuthClientLive"]
        ),
        .library(
            name: "DataClient",
            targets: ["DataClient"]
        ),
        .library(
            name: "Models",
            targets: ["Models"]
        ),
        .library(
            name: "PreviewClient",
            targets: ["PreviewClient"]
        ),
        .library(
            name: "StockClient",
            targets: ["StockClient"]
        ),
        .library(
            name: "StockClientLive",
            targets: ["StockClientLive"]
        ),
    ],
    dependencies: [
        .package(
            url: "git@github.com:pointfreeco/swift-composable-architecture.git",
            branch: "shared-state-beta"
        ),
        .package(
            url: "git@github.com:firebase/firebase-ios-sdk.git",
            from: "10.24.0"
        )
    ],
    targets: [
        .target(
            name: "AuthClient",
            dependencies: ["Models"]
        ),
        .target(
            name: "AuthClientLive",
            dependencies: [
                "AuthClient",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "DataClient",
            dependencies: ["Models"]
        ),
        .target(
            name: "Models",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "PreviewClient"
        ),
        .target(
            name: "StockClient",
            dependencies: ["Models"]
        ),
        .target(
            name: "StockClientLive",
            dependencies: [
                "StockClient",
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        )
    ]
)
