// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "StreamReader",
    products: [
        .library(
            name: "StreamReader",
            targets: ["StreamReader"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "StreamReader",
            dependencies: []),
        
        .testTarget(
            name: "StreamReaderTests",
            dependencies: ["StreamReader"]),
        ]
)
