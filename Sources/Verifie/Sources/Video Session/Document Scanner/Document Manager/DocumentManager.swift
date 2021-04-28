//
//  DocumentManager.swift
//  Verifie
//
//  Created by Misha Torosyan on 4/23/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import Vision
import AVFoundation
import UIKit

protocol DocumentManagerDelegate: class {
    
    func documentManager(_ sender: DocumentManager, didReceive documentImage: UIImage)
    
    func documentManager(_ sender: DocumentManager,
                         didReceiveMRZChecked documentImage: UIImage,
                         documentType: String)
}

enum DocumentManagerScanType {
    case passport
    case idCard
    case idCardMRZ
}

final class DocumentManager {
    
    //    MARK: - Internal Members
    weak var delegate: DocumentManagerDelegate?
    
    //    MARK: - Private Members
    private let imageDetector = ImageDetector()
    
    
    //    MARK: - Internal Functions
    func check(_ sampleBuffer: CMSampleBuffer, for type: DocumentManagerScanType) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            debugPrint("unable to get image from sample buffer")
            return
        }
        
        switch type {
        case .idCard:
            detectIdCard(frame) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.delegate?.documentManager(self, didReceive: result)
                default:
                    break
                }
            }
        case .passport, .idCardMRZ:
            detectMRZ(frame, for: type) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let (documentImage, doucmentType)):
                    self.delegate?.documentManager(self,
                                                   didReceiveMRZChecked: documentImage,
                                                   documentType: doucmentType)
                default:
                    break
                }
            }
        }
    }
    
    
    //    MARK: - Private Functions
    private func detectIdCard(_ sampleBuffer: CVPixelBuffer,
                              completion: @escaping (ImageDetectorResult<(UIImage)>) -> Void) {
        
        
        imageDetector.detectDocument(sampleBuffer, scanType: .idCard) { [weak self] (result) in
            switch result {
            case .success(let document):
                guard let self = self else { completion(.failure(nil)); return }
                self.imageDetector.detectFace(document) { (result) in
                    switch result {
                    case .success(_):
                        completion(.success(document))
                    case .notFound:
                        completion(.notFound)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .notFound:
                completion(.notFound)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func detectMRZ(_ sampleBuffer: CVPixelBuffer,
                           for type: DocumentManagerScanType,
                           completion: @escaping (ImageDetectorResult<(UIImage, String)>) -> Void) {
        
        imageDetector.detectDocument(sampleBuffer, scanType: type) { [weak self] (result) in
            switch result {
            case .success(let document):
                guard let self = self else { completion(.failure(nil)); return }
                self.imageDetector.detectMRZ(document) { (result) in
                    switch result {
                    case .success(let documentType):
                        completion(.success((document, documentType)))
                    case .notFound:
                        completion(.notFound)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .notFound:
                completion(.notFound)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

