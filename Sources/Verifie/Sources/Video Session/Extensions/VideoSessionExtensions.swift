//
//  VideoSessionExtensions.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/1/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import AVFoundation
import UIKit

extension UIDeviceOrientation {
    
    var videoOrientation: AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        default:
            return .portrait
        }
    }
    
    var imageOrientation: UIImage.Orientation {
        switch UIDevice.current.orientation {
        case .faceUp, .landscapeLeft, .landscapeRight:
            return .up
        default:
            return .right
        }
    }
    
    
    var imageOrientationMirrored: UIImage.Orientation {
        switch self {
        case .portraitUpsideDown:
            return .left
        case .landscapeLeft:
            return .down
        case .landscapeRight:
            return .up
        default:
            return .right
        }
    }
}

extension CameraPosition {
    var deviceType: DeviceType {
        switch self {
        case .back:
            return .backCamera
        case .front:
            return .frontCamera
        }
    }
}

extension FlashMode {
    
    var captureTorchMode: AVCaptureDevice.TorchMode {
        switch self {
        case .off: return .off
        case .on: return .on
        case .auto: return .auto
        }
    }
    
    var captureFlashMode: AVCaptureDevice.FlashMode {
        switch self {
        case .off: return .off
        case .on: return .on
        case .auto: return .auto
        }
    }
}
