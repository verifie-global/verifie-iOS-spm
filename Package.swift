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
        .library(name: "Verifie", targets: ["Verifie"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(url: "https://github.com/JonasGessner/JGProgressHUD.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/SwiftyTesseract/SwiftyTesseract.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "Verifie",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "JGProgressHUD", package: "JGProgressHUD"),
                .product(name: "SwiftyTesseract", package: "SwiftyTesseract")
            ],
            resources: [
                .copy("Resources/ML Models/Liveness.mlmodelc"),
                .copy("Resources/tessdata/ocrb.traineddata")
            ])
    ]
)
