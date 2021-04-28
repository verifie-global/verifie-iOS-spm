//
//  HumanDetectorSession.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/1/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit
import AVFoundation

protocol HumanDetectorSessionDelegate: class {
    
    func humanDetectorSession(_ session: HumanDetectorSession,
                              didReceive result: LivenessManagerResult,
                              with sourceImage: UIImage?)
    
    func humanDetectorSession(_ session: HumanDetectorSession, didReceive livenessPercent: Double)
}

final class HumanDetectorSession: VideoSession {
    
    //    MARK: - Members
    override var captureDeviceInput: AVCaptureDeviceInput? {
        didSet {
            self.faceDetectionBoxes.forEach({ $0.removeFromSuperview() })
            self.faceDetectionBoxes = []
        }
    }
    
    var cameraPosition = CameraPosition.front {
        didSet {
            do {
                let deviceInput = try VideoSession.captureDeviceInput(type: self.cameraPosition.deviceType)
                self.captureDeviceInput = deviceInput
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    var cameraDetection = CameraDetection.none {
        didSet {
            if oldValue == self.cameraDetection { return }
            
            for output in self.session.outputs {
                if output is AVCaptureMetadataOutput {
                    self.session.removeOutput(output)
                }
            }
            
            self.faceDetectionBoxes.forEach({ $0.removeFromSuperview() })
            self.faceDetectionBoxes = []
            
            if self.cameraDetection == .faces {
                let metadataOutput = AVCaptureMetadataOutput()
                self.session.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                if metadataOutput.availableMetadataObjectTypes.contains(.face) {
                    metadataOutput.metadataObjectTypes = [.face]
                }
            }
        }
    }
    
    private var videoDataOutput: AVCaptureVideoDataOutput! {
        didSet {
            if oldValue == self.videoDataOutput { return }
            
            for output in self.session.outputs {
                if output is AVCaptureVideoDataOutput {
                    self.session.removeOutput(output)
                }
            }
            self.session.addOutput(videoDataOutput)
            let queue = DispatchQueue(label: "AVCaptureVideoDataOutputQueue")
            self.videoDataOutput.setSampleBufferDelegate(self, queue: queue)
        }
    }
    
    weak var delegate: HumanDetectorSessionDelegate?
    
    private var faceDetectionBoxes: [UIView] = []
    
    private let livenessManager = LivenessManager()
    
    
    //    MARK: - Initializers
    init(position: CameraPosition = .front,
         detection: CameraDetection = .none,
         delegate: HumanDetectorSessionDelegate? = nil) {
        
        super.init()

        defer {
            cameraPosition = position
            cameraDetection = detection
            videoDataOutput = AVCaptureVideoDataOutput()
        }

        session.sessionPreset = .medium
        livenessManager.delegate = self
        self.delegate = delegate
    }
    
    
    //    MARK: - Internal Functions
    func resetFailuresCount() {
        
        livenessManager.resetFailuresCount()
    }
}

extension HumanDetectorSession: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        let faceMetadataObjects = metadataObjects.filter({ $0.type == .face })

        if faceMetadataObjects.count > self.faceDetectionBoxes.count {
            for _ in 0..<faceMetadataObjects.count - self.faceDetectionBoxes.count {
                let view = UIView()
                view.layer.borderColor = UIColor.green.cgColor
                view.layer.borderWidth = 1
                self.overlayView?.addSubview(view)
                self.faceDetectionBoxes.append(view)
            }
        } else if faceMetadataObjects.count < self.faceDetectionBoxes.count {
            for _ in 0..<self.faceDetectionBoxes.count - faceMetadataObjects.count {
                self.faceDetectionBoxes.popLast()?.removeFromSuperview()
            }
        }

        for i in 0..<faceMetadataObjects.count {
            if let transformedMetadataObject = self.previewLayer?.transformedMetadataObject(for: faceMetadataObjects[i]) {
                self.faceDetectionBoxes[i].frame = transformedMetadataObject.bounds
            } else {
                self.faceDetectionBoxes[i].frame = CGRect.zero
            }
        }
    }
}

extension HumanDetectorSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        connection.videoOrientation = UIDevice.current.orientation.videoOrientation

        DispatchQueue.global().async {
            
            if let image = sampleBuffer.image() {
                self.livenessManager.check(image)
            }
        }
    }
}

extension HumanDetectorSession: LivenessManagerDelegate {
    
    func livenessManager(_ sender: LivenessManager,
                         didReceive result: LivenessManagerResult,
                         faceImage: UIImage?) {
        
        delegate?.humanDetectorSession(self, didReceive: result, with: faceImage)
    }
    
    func livenessManager(_ sender: LivenessManager, didUpdate livenessPercent: Double) {
        
        delegate?.humanDetectorSession(self, didReceive: livenessPercent)
    }
}

