//
//  VideoSession.swift
//  Verifie
//
//  Created by Misha Torosyan on 4/28/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import AVFoundation
import UIKit


private extension DeviceType {
    
    var captureDeviceType: AVCaptureDevice.DeviceType {
        switch self {
        case .frontCamera, .backCamera:
            return .builtInWideAngleCamera
        }
    }
    
    var captureMediaType: AVMediaType {
        switch self {
        case .frontCamera, .backCamera:
            return .video
        }
    }
    
    var capturePosition: AVCaptureDevice.Position {
        switch self {
        case .frontCamera:
            return .front
        case .backCamera:
            return .back
        }
    }
}


class VideoSession: NSObject {
    
    //    MARK: - Properties
    /// Capture Session
    let session: AVCaptureSession
    
    
    /// Preview layer for video rendering
    private (set) var previewLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            self.previewLayer?.masksToBounds = true
            oldValue?.removeFromSuperlayer()
        }
    }
    
    /// View to display rendered viedo layer
    private (set) var overlayView: VerifieVideoSessionPreviewView!
    
    var captureDeviceInput: AVCaptureDeviceInput? {
        didSet {
            
            if let captureDeviceInput = self.captureDeviceInput {
                self.session.addInput(captureDeviceInput)
            }
        }
    }
    
    /// Flash mode for image capturing
    var flashMode = FlashMode.auto {
        didSet {

            guard let device = self.captureDeviceInput?.device else {
                return
            }
            
            do {
                try device.lockForConfiguration()
                if device.isTorchModeSupported(self.flashMode.captureTorchMode) {
                    device.torchMode = self.flashMode.captureTorchMode
                }
                device.unlockForConfiguration()
            } catch {
                //
            }
        }
    }
    
    
    //    MARK: - Internal functions
    /// Initializer
    override init() {
        
        session = AVCaptureSession()
    }
    
    /// Start the AVCaptureSession session
    func start() throws {
        
        guard let _ = overlayView else {
            throw VerifieError.missingPreviewView
        }
        
        session.startRunning()
    }
    
    /// Stop the AVCaptureSession session
    func stop() {
        
        session.stopRunning()
    }
    
    /// Set preview layer for displaying the rendered video
    ///
    /// - Parameter previewView: view to display rendered video layer
    func set(previewView: VerifieVideoSessionPreviewView) {
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewView.previewLayer = previewLayer
        
        overlayView = previewView
        self.previewLayer = previewLayer
    }
    
    
    //    MARK: - Static functions
    /// Creates and returns input with given parameters
    ///
    /// - Parameter type: Device type (front or back camera)
    /// - Returns: AVCaptureDeviceInput device
    /// - Throws: VideoSessionError error if device not found
    static func captureDeviceInput(type: DeviceType) throws -> AVCaptureDeviceInput {
        
        let captureDevices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [type.captureDeviceType],
            mediaType: type.captureMediaType,
            position: type.capturePosition)
        
        guard let captureDevice = captureDevices.devices.first else {
            throw VideoSessionError.captureDeviceNotFound
        }
        
        return try AVCaptureDeviceInput(device: captureDevice)
    }
}
