// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .iOS(.v17), .macOS(.v13)
    ],
    
    products: [
        .library(
            name: "Chat",
            targets: ["Chat"]),
        .library(
            name: "Models",
            targets: ["Models"]),
        .library(
            name: "Profile",
            targets: ["Profile"]),
        .library(
            name: "TestHelper",
            targets: ["TestHelper"]),
        .library(
            name: "Login",
            targets: ["Login"]
        )
    ],
    
    dependencies: [
        .package(path: "../Leaf"),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-custom-dump",
            from: "1.1.1"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "10.20.0"
        )
    ],
    targets: [
        .target(
            name: "Chat",
            dependencies: [
                "Leaf",
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "ChatTests",
            dependencies: [
                "Chat", "TestHelper"
            ]
        ),
        .target(
            name: "Models"
        ),
        .target(
            name: "Profile",
            dependencies: ["Leaf", "Models"]
        ),
        .testTarget(
            name: "ProfileTests",
            dependencies: ["Leaf", "Models", "Profile"]
        ),
        .target(
            name: "TestHelper",
            dependencies: [
                .product(name: "CustomDump", package: "swift-custom-dump"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .target(
            name: "Login",
            dependencies: [
                "Leaf",
                "Models",
                .product (name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "LoginTests",
            dependencies: ["Leaf", "Models", "Login"]
        ),
    ]
)

