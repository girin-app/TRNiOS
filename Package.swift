// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TRNiOS",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TRNiOS",
            targets: ["TRNiOS"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Girin-Wallet/Web3.swift.git", branch: "feature/block-info"),
        .package(url: "https://github.com/Girin-Wallet/WalletKit", branch: "main"),
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
            ]
        ),
        .testTarget(
            name: "TRNiOSTests",
            dependencies: ["TRNiOS"]),
    ]
)
