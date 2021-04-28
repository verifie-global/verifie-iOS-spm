//
//  VerifieColorConfigs.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/16/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

@objcMembers public class VerifieColorConfigs: NSObject {
    
    /// Color for the document cropper frame and the text above. Default `.white`
    public let docCropperFrameColor: UIColor
    
    public init(docCropperFrameColor: UIColor) {
        
        self.docCropperFrameColor = docCropperFrameColor
        
        super.init()
    }
    
    public static func `default`() -> VerifieColorConfigs {
        
        let configs = VerifieColorConfigs(docCropperFrameColor: .white)
        
        return configs
    }
}
