//
//  VideoSessionEnums.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/1/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

enum VideoSessionError: Error {
    
    case captureDeviceNotFound
    case error(String)
}

enum DeviceType: UInt {
    
    case frontCamera
    case backCamera
}

enum CameraPosition: UInt {
    
    case front
    case back
}

enum FlashMode: UInt {
    
    case off
    case on
    case auto
}

enum CameraDetection: UInt {
    
    case none
    case faces
}
