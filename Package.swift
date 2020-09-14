// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cinema-Clerk",
    dependencies: [
        .package(url: "https://github.com/Azoy/Sword", .revision("d53918cb208e422e9b32a472a71e9531df0fb741")), //from: "0.9.2" .revision("d53918cb208e422e9b32a472a71e9531df0fb741")
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
