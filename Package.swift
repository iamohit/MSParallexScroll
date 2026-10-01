// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MSParallexScroll",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "MSParallexScroll", targets: ["MSParallexScroll"])
    ],
    targets: [
        .target(name: "MSParallexScroll")
    ]
)
