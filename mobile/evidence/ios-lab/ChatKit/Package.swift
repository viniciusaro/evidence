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
//            branch: "shared-state-beta"
            from: "1.9.3"
        ),
        .package(
            url: "git@github.com:firebase/firebase-ios-sdk.git",
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
