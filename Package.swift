// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExifTool",
    platforms: [
        .macOS(.v11),.iOS(.v14) ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ExifTool",
            targets: ["ExifTool"])
    ],
    targets: [
        .target(
            name: "ExifTool"),
        .testTarget(
            name: "ExifToolTests",
            dependencies: ["ExifTool"],
            resources: [
                .copy("Resources")
            ])
    ]
)
