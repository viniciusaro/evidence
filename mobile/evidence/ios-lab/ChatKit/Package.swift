// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChatKit",
    platforms: [
        .iOS(.v17), .macOS(.v13)
    ],
    products: [
        .library(
            name: "ChatKit",
            targets: ["ChatKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.9.2"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "10.24.0"
        )
    ],
    targets: [
        .target(
            name: "ChatKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        )
    ]
)
