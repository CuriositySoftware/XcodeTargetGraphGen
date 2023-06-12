// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeTargetGraphGen",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "xcgraphgen", targets: ["XcodeTargetGraphGen"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/tuist/XcodeProj.git",
            .upToNextMajor(from: "8.10.0")
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .upToNextMajor(from: "1.2.2")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "XcodeTargetGraphGen",
            dependencies: [
                "Generator",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/XcodeTargetGraphGen"
        ),
        .target(
            name: "Generator",
            dependencies: [
                "Mermaid",
                "Client",
                "Value",
                .product(name: "XcodeProj", package: "XcodeProj"),
            ],
            path: "Sources/Generator"
        ),
        .target(
            name: "Mermaid",
            dependencies: [
                "Converter"
            ],
            path: "Sources/Formatter"
        ),
        .target(
            name: "Value",
            path: "Sources/Value"
        ),
        .target(
            name: "Converter",
            dependencies: [
                "Value"
            ],
            path: "Sources/Converter"
        ),
        .target(
            name: "Client",
            path: "Sources/Client"
        ),
        .testTarget(
            name: "XcodeTargetGraphGenTests",
            dependencies: [
                "XcodeTargetGraphGen",
                "Mermaid"
            ],
            path: "Tests"
        ),
    ]
)
