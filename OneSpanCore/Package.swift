// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OneSpanCore",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "OneSpanCore",
            targets: ["OneSpanCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        .target(
            name: "OneSpanCore",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Swinject", package: "Swinject")
            ],
            resources: [.process("CoreResources")]
        ),
        .testTarget(
            name: "OneSpanCoreTests",
            dependencies: ["OneSpanCore"],
            resources: [.copy("OneSpanCore")]
        ),
    ]
)
