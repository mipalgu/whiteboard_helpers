// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "whiteboard_helpers",
    products: [
        .library(
            name: "whiteboard_helpers",
            targets: ["whiteboard_helpers"])
    ],
    dependencies: [
        .package(url: "https://github.com/mipalgu/swift_helpers.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "whiteboard_helpers",
            dependencies: ["swift_helpers"]),
        .testTarget(
            name: "whiteboard_helpersTests",
            dependencies: ["whiteboard_helpers"])
    ]
)
