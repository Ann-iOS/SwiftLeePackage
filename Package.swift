// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLeePackage",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.  Package.Dependency.Requirement.branch("main")
        .library(
            name: "SwiftLeePackage",targets: ["SwiftLeePackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/WeTransfer/Mocker.git", from: "2.0.0"),
//            .package(url: "https://github.com/hyperledger/sawtooth-sdk-swift.git",.branch("main"))
        .package(name: "SawtoothSigning", url: "https://github.com/hyperledger/sawtooth-sdk-swift.git", .branch("main"))
//        .package(url: "https://github.com/Boilertalk/secp256k1.swift",from: "0.1.4")
//        .package(url: "https://github.com/hyperledger/sawtooth-sdk-swift.git", from: "0.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "SwiftLeePackage", dependencies: ["Mocker","SawtoothSigning"]),
//        .target(name: "SwiftLeePackage", dependencies: ["secp256k1"],path: "SawtoothSigning"),
        /// Add it to your test target in the dependencies array:
//        .testTarget(name: "SwiftLeePackageTests", dependencies: ["SwiftLeePackage", "SawtoothSigning"])
    ]
)
