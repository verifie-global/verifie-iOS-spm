//
//  LivenessManager.swift
//  Verifie
//
//  Created by Misha Torosyan on 10/21/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit
import Vision

enum LivenessManagerResult {
    case moveCloser
    case moveAway
    case holdStill
    case live
    case faceFailed
    case eyesFailed
    case timeout
}

enum LivenessMLResult: String {
    case real
    case fake
}

protocol LivenessManagerDelegate: class {
    
    func livenessManager(_ sender: LivenessManager,
                         didReceive result: LivenessManagerResult,
                         faceImage: UIImage?)
    
    func livenessManager(_ sender: LivenessManager, didUpdate livenessPercent: Double)
}

final class LivenessManager {
    
    //    MARK: - Private Members
    private let modelImageSize = CGSize(width: 64, height: 64)
    private var predValue = 0.1
    private let validRealsPercent = 0.3
    private let faceFailuresMax = 240
    private let fakesMax = 600
    private let faceSolidityMin = 0.22
    private let faceSolidityMax = 0.4
    private var faceFailuresCount = 0
    private var fakes: Int = 0
    private var reals: Int = 0
    private var isPersonLive = false
    private let livenessModel: Liveness
    private var realPersonImage: UIImage?
    private let detectionMinDuration = 5.0
    private lazy var detectionStartDate: Date = {
        return Date()
    }()
    
    
    //    MARK: - Internal Members
    weak var delegate: LivenessManagerDelegate?
    
    init() {
        
        self.livenessModel = try! Liveness(configuration: MLModelConfiguration())
    }
    
    
    //    MARK: - Internal Functions
    func check(_ sourceImage: UIImage) {
        
        if isPersonLive {
            delegate?.livenessManager(self, didReceive: .live, faceImage: sourceImage)
            return
        }
        
        if faceFailuresCount == faceFailuresMax {
            faceDetectionFailed(faceImage: sourceImage)
            return
        }
        
        if fakes == fakesMax {
            detectionTimeout()
            return
        }
        
        detectFaces(sourceImage) { [weak self] (result) in
            
            guard let self = self else { return }
            //            debugPrint("reals: \(self.reals)")
            //            debugPrint("fakes: \(self.fakes)")
            switch result {
            case .success(let result):
                guard
                    let (faceImage, faceRect) = result.first,
                    let resizedImage = faceImage.resizeImageForced(targetSize: self.modelImageSize)
                    else {
                        self.faceFailuresCount += 1
                        self.isPersonLive = false
                        return
                }
                
                let fullArea = sourceImage.size.width * sourceImage.size.height
                let faceArea = faceRect.width * faceRect.height
                let solidity = Double(faceArea / fullArea)
                
                if solidity > self.faceSolidityMin {
                    
                    if solidity < self.faceSolidityMax {
                        
                        self.faceFailuresCount = 0
                        self.holdStill(faceImage: sourceImage)
                        self.handle(detectedFace: resizedImage, sourceImage: sourceImage)
                    }
                    else {
                        self.moveAway(faceImage: sourceImage)
                    }
                }
                else {
                    self.moveCloser(faceImage: sourceImage)
                }
                
            default:
                self.faceFailuresCount += 1
                self.isPersonLive = false
            }
        }
    }
    
    func resetFailuresCount() {
        
        faceFailuresCount = 0
    }
    
    
    //    MARK: - Private Functions
    private func handle(detectedFace faceImage: UIImage, sourceImage: UIImage) {
        
        guard
            let imageBuffer = faceImage.pixelBuffer(),
            let prediction = try? livenessModel.prediction(image: imageBuffer),
            let maxOutput = prediction.output1.max (by: {a, b in a.value < b.value}),
            let result = LivenessMLResult(rawValue: maxOutput.key)
            else { return }
        
        if maxOutput.value > predValue && result == .real {
            
            reals += 1
            realPersonImage = sourceImage
            
            let totalCount = Double(reals + fakes)
            let percent = Double(reals)/totalCount
            let detectionDuration = Date().timeIntervalSince(detectionStartDate)
            let livenessPercent = percent/validRealsPercent > 1 ? 1 : percent/validRealsPercent
            let durationPercent = detectionDuration/detectionMinDuration > 1 ? 1 : detectionDuration/detectionMinDuration
            let totalPercent = livenessPercent/2 + durationPercent/2
            
            delegate?.livenessManager(self, didUpdate: totalPercent)
            
            if percent >= validRealsPercent
                && detectionDuration >= detectionMinDuration,
                let liveImage = realPersonImage {
                
                isPersonLive = true
                livePersonDetected(faceImage: liveImage)
            }
        }
        else {
            fakes += 1
        }
    }
    
    private func moveCloser(faceImage: UIImage) {
        
        delegate?.livenessManager(self, didReceive: .moveCloser, faceImage: faceImage)
    }
    
    private func moveAway(faceImage: UIImage) {
        
        delegate?.livenessManager(self, didReceive: .moveAway, faceImage: faceImage)
    }
    
    private func holdStill(faceImage: UIImage) {
        
        delegate?.livenessManager(self, didReceive: .holdStill, faceImage: faceImage)
    }
    
    private func faceDetectionFailed(faceImage: UIImage) {
        
        delegate?.livenessManager(self, didReceive: .faceFailed, faceImage: faceImage)
    }
    
    private func livePersonDetected(faceImage: UIImage) {
        
        delegate?.livenessManager(self, didReceive: .live, faceImage: faceImage)
    }
    
    private func detectionTimeout() {
        
        delegate?.livenessManager(self, didReceive: .timeout, faceImage: nil)
    }
}

//    MARK: - Vision Face Detection
private extension LivenessManager {
    
    enum ImageDetectResult<T> {
        
        case success([T])
        case notFound
        case failure(Error)
    }
    
    typealias FaceRect = CGRect
    
    private func detectFaces(_ image: UIImage,
                             completion: @escaping (ImageDetectResult<(UIImage, FaceRect)>) -> Void) {
        
        if let image = image.cgImage {
            
            detectFaces(image) { (result) in
                
                switch result {
                case .success(let faces):
                    let faces = faces.map { cgImage, faceRect -> (UIImage, FaceRect) in
                        return (UIImage(cgImage: cgImage), faceRect)
                    }
                    completion(.success(faces))
                case .notFound:
                    completion(.notFound)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else {
            completion(.notFound)
        }
    }
    
    private func detectFaces(_ image: CGImage,
                             completion: @escaping (ImageDetectResult<(CGImage, FaceRect)>) -> Void) {
        
        guard image.isSuitable() else {
            completion(.notFound)
            return
        }
        
        let req = VNDetectFaceRectanglesRequest { request, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            let faceImages = request.results?.map({ result -> (CGImage, FaceRect)? in
                
                guard let face = result as? VNFaceObservation,
                    face.boundingBox.origin.x >= 0.2 && face.boundingBox.origin.x <= 0.3,
                    face.boundingBox.origin.y >= 0.25 && face.boundingBox.origin.y <= 0.35
                    else { return nil }
                let faceImage = self.cropFace(from: image, object: face)
                return faceImage
            }).compactMap { $0 }
            
            guard let result = faceImages, result.count > 0 else {
                completion(.notFound)
                return
            }
            
            completion(.success(result))
        }
        
        do {
            try VNImageRequestHandler(cgImage: image, options: [:]).perform([req])
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func cropFace(from image: CGImage,
                          object: VNDetectedObjectObservation) -> (CGImage, FaceRect)? {
        
        let width = object.boundingBox.width * CGFloat(image.width)
        let height = object.boundingBox.height * CGFloat(image.height)
        let x = object.boundingBox.origin.x * CGFloat(image.width)
        let y = (1 - object.boundingBox.origin.y) * CGFloat(image.height) - height
        let croppingRect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let image = image.cropping(to: croppingRect) else {
            return nil
        }
        return (image, croppingRect)
    }
}
