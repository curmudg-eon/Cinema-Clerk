// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cinema-Clerk",
    dependencies: [
        .package(url: "https://github.com/Azoy/Sword", from: "0.9.2"), //from: "0.9.2" .revision("ca066c5986646a46d61d69d320b50183b5cf6e86")
        .package(name: "SQLite.swift", url: "https://github.com/stephencelis/SQLite.swift", from: "0.12.0"),
    ],
    targets: [
        .target(
            name: "Cinema-Clerk",
            dependencies: [
                "Sword",
                .product(name: "SQLite", package: "SQLite.swift"),
        ]),
//                .testTarget(
//                    name: "Cinema-ClerkTests",
//                    dependencies: ["Cinema-Clerk"]),
                
    ]
)
