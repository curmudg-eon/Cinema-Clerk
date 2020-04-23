// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cinema-Clerk",
    dependencies: [
        .package(url: "https://github.com/Azoy/Sword", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "Cinema-Clerk",
            dependencies: ["Sword"]),
        .testTarget(
            name: "Cinema-ClerkTests",
            dependencies: ["Cinema-Clerk"]),
    ]
)
