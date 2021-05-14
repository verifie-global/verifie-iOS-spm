//
//  ImageDetector.swift
//  Verifie
//
//  Created by Misha Torosyan on 4/23/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import AVFoundation
import Vision
import SwiftyTesseract
import UIKit

enum ImageDetectorResult<T> {
    case success(T)
    case notFound
    case failure(Error?)
}

final class ImageDetector {
    
    //    MARK: - Private Members
    private let mrzParser = QKMRZParser(ocrCorrection: true)
    private var tesseract: Tesseract!
    private var mtlDevice: MTLDevice!
    private var mtlCommandQueue: MTLCommandQueue!
    
    
    //    MARK: - Initializers
    init() {
        
        FilterVendor.registerFilters()
        setupTesseract()
    }
    
    
    //    MARK: - Internal Functions
    private func setupTesseract() {
        
        tesseract = Tesseract(language: .custom("ocrb"),
                              dataSource: Bundle.sources(),
                              engineMode: .tesseractLstmCombined,
                              configure: { () -> (TessBaseAPI) -> Void in
                                set(.disallowlist, value: "abcdefghijklmopqrstuvwxyz\\/,.-:")
                                set(.allowlist, value: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789><")
                              })
    }
    
    
    //    MARK: - Internal Functions
    func detectFace(_ image: UIImage,
                           completion: @escaping (ImageDetectorResult<(UIImage, CGRect)>) -> Void) {

        guard
            let image = image.cgImage,
            image.isSuitable() else {
                completion(.notFound)
                return
        }

        let req = VNDetectFaceRectanglesRequest { request, error in

            guard error == nil else {
                completion(.failure(error!))
                return
            }

            let faceImages = request.results?.map({ result -> (UIImage, CGRect)? in
                guard let face = result as? VNFaceObservation else { return nil }
                let faceImage = self.cropObject(object: face, from: image)
                return faceImage
            }).compactMap { $0 }

            guard let result = faceImages?.first else {
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
    
    
    func detectDocument(_ imageBuffer: CVPixelBuffer,
                        scanType: DocumentManagerScanType,
                        completion: @escaping (ImageDetectorResult<(UIImage)>) -> Void) {
        
        
        let rectangelReq = VNDetectRectanglesRequest { request, error in
            
            guard error == nil else {
                completion(.failure(error))
                return
            }
            
            guard let documentRect = request.results?.first as? VNRectangleObservation else {
                completion(.notFound)
                return
            }
            
            let image = self.correctedImage(documentRect, from: imageBuffer)
            completion(.success(image))
        }
        
        switch scanType {
        case .idCard, .idCardMRZ:
            rectangelReq.minimumAspectRatio = VNAspectRatio(0.6)
            rectangelReq.maximumAspectRatio = VNAspectRatio(0.7)
        case .passport:
            rectangelReq.minimumAspectRatio = VNAspectRatio(0.6)
            rectangelReq.maximumAspectRatio = VNAspectRatio(0.75)
        }
        rectangelReq.minimumSize = 0.35
        rectangelReq.maximumObservations = 1
        
        do {
            try VNImageRequestHandler(cvPixelBuffer: imageBuffer, options: [:]).perform([rectangelReq])
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func detectMRZ(_ image: UIImage, completion: @escaping (ImageDetectorResult<String>) -> Void) {
        
        guard
            let documentImage = image.cgImage,
            documentImage.isSuitable() else {
                completion(.notFound)
                return
        }
        
        let detectTextRectangles = VNDetectTextRectanglesRequest { request, error in
            guard error == nil else {
                return
            }
            
            guard let results = request.results as? [VNTextObservation] else {
                return
            }
            
            let imageWidth = CGFloat(documentImage.width)
            let imageHeight = CGFloat(documentImage.height)
            let transform = CGAffineTransform.identity.scaledBy(x: imageWidth, y: -imageHeight).translatedBy(x: 0, y: -1)
            let mrzTextRectangles = results.map({ $0.boundingBox.applying(transform) }).filter({ $0.width > (imageWidth * 0.8) })
            let mrzRegionRect = mrzTextRectangles.reduce(into: CGRect.null, { $0 = $0.union($1) })
            
            guard mrzRegionRect.height <= (imageHeight * 0.4) else { // Avoid processing the full image (can occur if there is a long text in the header)
                return
            }
            
            if let mrzTextImage = documentImage.cropping(to: mrzRegionRect) {
                if let mrzResult = self.mrz(from: mrzTextImage), mrzResult.allCheckDigitsValid {
                    completion(.success(mrzResult.documentType))
                }
            }
        }
        
        do {
            try VNImageRequestHandler(cgImage: documentImage, options: [:]).perform([detectTextRectangles])
        } catch let error {
            completion(.failure(error))
        }
    }
    
    
    //    MARK: - Private Functions
    private func cropObject(object: VNDetectedObjectObservation,
                                   from image: CGImage) -> (UIImage, CGRect)? {
        
        let width = object.boundingBox.width * CGFloat(image.width)
        let height = object.boundingBox.height * CGFloat(image.height)
        let x = object.boundingBox.origin.x * CGFloat(image.width)
        let y = (1 - object.boundingBox.origin.y) * CGFloat(image.height) - height
        
        let croppingRect = CGRect(x: x, y: y, width: width, height: height)
        guard let image = image.cropping(to: croppingRect) else {
            return nil
        }
        
        return (UIImage(cgImage: image), croppingRect)
    }
    
    
    //    MARK: MRZ
    private func mrz(from cgImage: CGImage) -> QKMRZResult? {
        let mrzTextImage = UIImage(cgImage: preprocessImage(cgImage))
        var recognizedString: String?
        
        let result = tesseract.performOCR(on: mrzTextImage)
        switch result {
        case .success(let text):
            recognizedString = text
        default:
            break
        }
        
        if let string = recognizedString, let mrzLines = mrzLines(from: string) {
            return mrzParser.parse(mrzLines: mrzLines)
        }
        
        return nil
    }
    
    private func preprocessImage(_ image: CGImage) -> CGImage {
        var inputImage = CIImage(cgImage: image)
        let averageLuminance = inputImage.averageLuminance
        var exposure = 0.5
        let threshold = (1 - pow(1 - averageLuminance, 0.2))
        
        if averageLuminance > 0.8 {
            exposure -= ((averageLuminance - 0.5) * 2)
        }
        
        if averageLuminance < 0.35 {
            exposure += pow(2, (0.5 - averageLuminance))
        }
        
        inputImage = inputImage.applyingFilter("CIExposureAdjust", parameters: ["inputEV": exposure])
            .applyingFilter("CILanczosScaleTransform", parameters: [kCIInputScaleKey: 2])
            .applyingFilter("LuminanceThresholdFilter", parameters: ["inputThreshold": threshold])
        
        return CIContext.shared.createCGImage(inputImage, from: inputImage.extent)!
    }
    
    private func mrzLines(from recognizedText: String) -> [String]? {
        let mrzString = recognizedText.replacingOccurrences(of: " ", with: "")
        var mrzLines = mrzString.components(separatedBy: "\n").filter({ !$0.isEmpty })
        
        // Remove garbage strings located at the beginning and at the end of the result
        if !mrzLines.isEmpty {
            let averageLineLength = (mrzLines.reduce(0, { $0 + $1.count }) / mrzLines.count)
            mrzLines = mrzLines.filter({ $0.count >= averageLineLength })
        }
        
        return mrzLines.isEmpty ? nil : mrzLines
    }
    
    func correctedImage(_ observation: VNRectangleObservation, from buffer: CVImageBuffer) -> UIImage {
        
        var ciImage = CIImage(cvImageBuffer: buffer)

        let topLeft = observation.topLeft.scaled(to: ciImage.extent.size)
        let topRight = observation.topRight.scaled(to: ciImage.extent.size)
        let bottomLeft = observation.bottomLeft.scaled(to: ciImage.extent.size)
        let bottomRight = observation.bottomRight.scaled(to: ciImage.extent.size)
        
        // pass those to the filter to extract/rectify the image
        ciImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: topLeft),
            "inputTopRight": CIVector(cgPoint: topRight),
            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
            "inputBottomRight": CIVector(cgPoint: bottomRight),
        ])

        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        let output = UIImage(cgImage: cgImage!)
        
        return output
    }
}


extension CGPoint {
   func scaled(to size: CGSize) -> CGPoint {
       return CGPoint(x: self.x * size.width,
                      y: self.y * size.height)
   }
}
