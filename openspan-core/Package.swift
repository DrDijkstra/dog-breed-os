// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "openspan-core",
    platforms: [
        .iOS(.v13), // Alamofire supports iOS 13 and above
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "openspan-core",
            targets: ["openspan-core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "openspan-core",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Swinject", package: "Swinject")
            ]),
        .testTarget(
            name: "openspan-coreTests",
            dependencies: ["openspan-core"]
        ),
    ]
)
