// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "MZArbeit",
    
    platforms: [.iOS(.v16), .macOS(.v14)],
    
    products: [
        .library(
            name: "MZArbeit",
            targets: ["MZArbeit"]
        ),
    ],
    
    targets: [
        .target(
            name: "MZArbeit"
        ),
        .testTarget(
            name: "MZArbeitTests",
            dependencies: ["MZArbeit"],
            resources: [.copy("Test Files/test.csv")]
        ),
    ]
)
