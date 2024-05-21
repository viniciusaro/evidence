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
        ),
        .package(
            url: "https://github.com/google/generative-ai-swift",
            from: "0.5.3"
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
            name: "OpenAIClient",
            dependencies: ["Models"]
        ),
        .target(
            name: "OpenAIClientLive",
            dependencies: [
                "OpenAIClient",
                .product(name: "GoogleGenerativeAI", package: "generative-ai-swift")
            ]
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
