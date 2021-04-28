//
//  CMSampleBufferExtension.swift
//  Verifie
//
//  Created by Misha Torosyan on 4/23/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import UIKit
import AVFoundation

extension CMSampleBuffer {
    
    func image() -> UIImage? {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(self) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
}


