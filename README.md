# Verifie
[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![codebeat-badge][codebeat-image]][codebeat-url]

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

## Development setup

Describe how to install all development dependencies and how to run an automated test-suite of some kind. Potentially do this for multiple platforms.

```sh
make install
```

## Author
Oxygen LLC

## License

Verifie is available under the Commercial license.
