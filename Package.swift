// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TRNiOS",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TRNiOS",
            targets: ["TRNiOS"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Girin-app/Web3.swift.git", branch: "test/package"),
        .package(url: "https://github.com/Girin-app/WalletKit", branch: "main"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TRNiOS",
            dependencies: [
                .product(name: "Web3", package: "Web3.swift"),
                .product(name: "Web3PromiseKit", package: "Web3.swift"),
                .product(name: "Web3ContractABI", package: "Web3.swift"),
                .product(name: "WalletKit", package: "WalletKit"),
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "TRNiOSTests",
            dependencies: [
                "TRNiOS"   
            ]),
    ]
)
