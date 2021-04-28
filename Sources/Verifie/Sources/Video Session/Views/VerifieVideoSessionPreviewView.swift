//
//  VerifieVideoSessionPreviewView.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/1/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit
import AVFoundation

@objc(VerifieVideoSessionPreviewView)

public class VerifieVideoSessionPreviewView: UIView {
    
    public var previewLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            
            previewLayer?.videoGravity = .resizeAspectFill
            
            if let previewLayer = previewLayer {
                self.layer.addSublayer(previewLayer)
            }
        }
    }
    
    public var videoOrientation: AVCaptureVideoOrientation? {
        didSet {
            if !autorotate {
                previewLayer?.connection?.videoOrientation = videoOrientation ?? .portrait
            }
        }
    }
    
    public var isVideoMirrored: Bool?
    
    /// Should automatically rotate video or not
    public var autorotate: Bool = true {
        didSet {
            if !self.autorotate {
                self.previewLayer?.connection?.videoOrientation = .portrait
            }
        }
    }
    
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        
        previewLayer?.frame = self.bounds
        
        if let isVideoMirrored = isVideoMirrored {
            self.previewLayer?.connection?.automaticallyAdjustsVideoMirroring = false
            self.previewLayer?.connection?.isVideoMirrored = isVideoMirrored
        }
        
        if autorotate {
            previewLayer?.connection?.videoOrientation = UIDevice.current.orientation.videoOrientation
        }
    }
}
