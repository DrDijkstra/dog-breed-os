// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OpenspanCore",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "OpenspanCore",
            targets: ["OpenspanCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        .target(
            name: "OpenspanCore",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Swinject", package: "Swinject")
            ],
            resources: [.process("CoreResources")]
        ),
        .testTarget(
            name: "OpenspanCoreTests",
            dependencies: ["OpenspanCore"],
            resources: [.copy("CoreResources")]
        ),
    ]
)
