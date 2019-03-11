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
        .package(url: "ssh://git.mipal.net/git/swift_helpers.git", .branch("master"))
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
