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
            name: "Clients",
            targets: [
                "AuthClient",
                "DataClient",
                "OpenAIClient",
                "PhotoClient",
                "PreviewClient",
                "StockClient"
            ]
        ),
        .library(
            name: "ClientsLive",
            targets: [
                "AuthClientLive",
                "DataClient",
                "OpenAIClientLive",
                "PhotoClientLive",
                "PreviewClient",
                "StockClientLive"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "git@github.com:pointfreeco/swift-composable-architecture.git",
            from: "1.10.2"
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
                .product(name: "FirebaseFunctions", package: "firebase-ios-sdk"),
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
            name: "OpenAIClient",
            dependencies: ["Models"]
        ),
        .target(
            name: "OpenAIClientLive",
            dependencies: [
                "OpenAIClient",
                .product(name: "FirebaseFunctions", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "PhotoClient",
            dependencies: ["Models"]
        ),
        .target(
            name: "PhotoClientLive",
            dependencies: ["PhotoClient"]
        ),
        .target(
            name: "PreviewClient",
            dependencies: ["Models"]
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
