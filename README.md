# Verifie
[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]

## Installation

#### Add this project on your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/verifie-global/verifie-iOS-spm")
    ]
)
```

#### Set privacy settings
- In your project's `Info.plist` file add these keys:  

**Key:** `NSCameraUsageDescription`  
**Type:** `String`  
**Value:** `Usage description...`

## Usage example

See example project.

## Author
Oxygen LLC

## License

Verifie is available under the Commercial license.

[https://github.com/verifie-global/verifie-iOS-spm](https://github.com/verifie-global)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
