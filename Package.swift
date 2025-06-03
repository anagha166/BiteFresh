// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BFresh",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "BFresh",
            targets: ["BFresh"]),
    ],
    dependencies: [
        .package(url: "https://github.com/google/generative-ai-swift.git", from: "0.5.0")
    ],
    targets: [
        .target(
            name: "BFresh",
            dependencies: [
                .product(name: "GoogleGenerativeAI", package: "generative-ai-swift")
            ]),
        .testTarget(
            name: "BFreshTests",
            dependencies: ["BFresh"]),
    ]
) 