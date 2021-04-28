//
//  DocScannerSession.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/9/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

protocol DocScannerSessionDelegate: class {
    
    func docScannerSession(_ sender: DocScannerSession, didScan docImage: UIImage)
    
    func docScannerSession(_ sender: DocScannerSession, didFailWith error: VerifieError)
}

class DocScannerSession: VideoSession {
    
    var cameraPosition = CameraPosition.back {
        didSet {
            do {
                let deviceInput = try VideoSession.captureDeviceInput(type: self.cameraPosition.deviceType)
                self.captureDeviceInput = deviceInput
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    var sessionScannerType: DocumentManagerScanType = .passport
    
    var imageOrientation: UIImage.Orientation!
    weak var delegate: DocScannerSessionDelegate?
    private var croppingAreaView: UIView!
    
    private let documentManger = DocumentManager()
    private var isStopped = false
    
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
    
    
    //    MARK: - Internal Functions
    init(position: CameraPosition = .back, delegate: DocScannerSessionDelegate? = nil) {
        
        super.init()
        
        defer {
            cameraPosition = position
            videoDataOutput = AVCaptureVideoDataOutput()
        }
        
        session.sessionPreset = .high
        
        documentManger.delegate = self
        self.delegate = delegate
    }
    
    override func stop() {
        
        self.isStopped = true
        
        super.stop()
    }
    
    
    //    MARK: - Internal Functions
    override func start() throws {
        
        isStopped = false
        
        try super.start()
        
        guard let _ = croppingAreaView else {
            throw VerifieError.missingCroppingAreaView
        }
    }
    
    func set(croppingAreaView: UIView) {
        
        self.croppingAreaView = croppingAreaView
    }
    
    
    //    MARK: - Private Functions
    func handle(captured image: UIImage) {
        
        if !isStopped {
            delegate?.docScannerSession(self, didScan: image)
        }
    }
    
    func handle(captured image: UIImage, documentType: String) {
        
        if !isStopped {
            switch VerifieDocumentType(stringValue: documentType) {
            case .idCard:
                if sessionScannerType != .idCardMRZ {
                    return
                }
            case .passport:
                if sessionScannerType != .passport {
                    return
                }
            default:
                return
            }
            
            delegate?.docScannerSession(self, didScan: image)
        }
    }
}

extension DocScannerSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        connection.videoOrientation = UIDevice.current.orientation.videoOrientation
        
        documentManger.check(sampleBuffer, for: sessionScannerType)
    }
}

extension DocScannerSession: DocumentManagerDelegate {
    
    func documentManager(_ sender: DocumentManager, didReceive documentImage: UIImage) {
        self.handle(captured: documentImage)
    }
    
    func documentManager(_ sender: DocumentManager,
                         didReceiveMRZChecked documentImage: UIImage,
                         documentType: String) {
        
        self.handle(captured: documentImage, documentType: documentType)
    }
}
