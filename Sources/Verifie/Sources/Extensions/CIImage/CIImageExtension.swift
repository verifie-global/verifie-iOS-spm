//
//  CIImageExtension.swift
//  Verifie
//
//  Created by Misha Torosyan on 4/25/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import UIKit

extension CIImage {
    var averageLuminance: Double {
        let vector = CIVector(cgRect: extent)
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: self, kCIInputExtentKey: vector])!
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        CIContext.shared.render(filter.outputImage!, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        let r = (Double(bitmap[0]) / 255) * 0.213
        let g = (Double(bitmap[1]) / 255) * 0.715
        let b = (Double(bitmap[2]) / 255) * 0.072
        
        return (r + g + b)
    }
}
