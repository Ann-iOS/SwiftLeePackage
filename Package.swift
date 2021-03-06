// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLeePackage",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "SwiftLeePackage",targets: ["SwiftLeePackage"]),
    ],
    dependencies: [
        .package(name: "SawtoothSigning", url: "https://github.com/hyperledger/sawtooth-sdk-swift.git", .branch("main")),
        .package(name: "CryptoSwift", url: "https://github.com/krzyzanowskim/CryptoSwift.git", .branch("master")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.3"),
    ],
    targets: [
//        .target(name: "SwiftLeePackage", dependencies: ["SawtoothSigning","CryptoSwift","Alamofire"]),
//        .testTarget(name: "SwiftLeePackageTests", dependencies: ["SwiftLeePackage", "SawtoothSigning","CryptoSwift","Alamofire"])

        .target(name: "SwiftLeePackage", dependencies: ["SawtoothSigning","CryptoSwift","Alamofire"],
                path: "Sources",
                publicHeadersPath: "../Sources"),

        .testTarget(name: "SwiftLeePackageTests", dependencies: ["SwiftLeePackage", "SawtoothSigning","CryptoSwift","Alamofire"]),
    ],
    swiftLanguageVersions: [.v5]
)
