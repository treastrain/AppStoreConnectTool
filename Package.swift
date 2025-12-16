// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AppStoreConnectTool",
    platforms: [.macOS(.v26)],
    products: [
        .executable(name: "asctool", targets: ["asctool"]),
        .library(name: "AppStoreConnectTool", targets: ["AppStoreConnectTool"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.7.0"),
        .package(url: "https://github.com/apple/swift-log", exact: "1.8.0"),
        .package(url: "https://github.com/treastrain/appstoreconnect-swift-sdk", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "asctool",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                "AppStoreConnectTool",
            ]
        ),
        .target(
            name: "AppStoreConnectTool",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "AppStoreConnect-Swift-SDK", package: "appstoreconnect-swift-sdk"),
            ]
        ),
    ]
)
