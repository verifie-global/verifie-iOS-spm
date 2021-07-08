// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Verifie",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "Verifie", type: .dynamic, targets: ["Verifie"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(url: "https://github.com/jdg/MBProgressHUD.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/SwiftyTesseract/SwiftyTesseract.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "Verifie",
            dependencies: ["Alamofire", "MBProgressHUD", "SwiftyTesseract"],
            exclude: ["Example"],
            resources: [
                .copy("Resources/ML Models/Liveness.mlmodelc"),
                .copy("Resources/tessdata")
            ])
    ]
)
