//
//  VerifieTextConfigs.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/16/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objcMembers public class VerifieTextConfigs: NSObject {
    
    /// Move phone closer text. Default `Move phone closer`
    public let movePhoneCloser: String
    
    /// Move phone away text. Default `Move phone away`
    public let movePhoneAway: String
    
    /// Hold still text. Default `Hold still`
    public let holdStill: String
        
    /// Face failed text. Default `Light face evenly`
    public let faceFailed: String
    
    /// Eyes failed text. Default `Light face evenly`
    public let eyesFailed: String
    
    /// Detection failed text. Default `Detection failed`
    public let detectionFailed: String
    
    /// Text config for document scanner screen
    public let documentScannerConfigs: VerifieDocumentScannerTextConfigs
    
    /// Text config for recommendation screen
    public let recommendationsConfigs: VerifieRecommendationsTextConfigs
    
    /// Text config for document instruction screen
    public let documentInstructionsConfigs: VerifieDocInstructionsTextConfigs
    
    
    public init(movePhoneCloser: String,
                movePhoneAway: String,
                holdStill: String,
                faceFailed: String,
                eyesFailed: String,
                detectionFailed: String,
                documentScannerConfigs: VerifieDocumentScannerTextConfigs = .default(),
                recommendationsConfigs: VerifieRecommendationsTextConfigs = .default(),
                documentInstructionsConfigs: VerifieDocInstructionsTextConfigs = .default()) {
        
        self.movePhoneCloser = movePhoneCloser
        self.movePhoneAway = movePhoneAway
        self.holdStill = holdStill
        self.faceFailed = faceFailed
        self.eyesFailed = eyesFailed
        self.detectionFailed = detectionFailed
        self.documentScannerConfigs = documentScannerConfigs
        self.recommendationsConfigs = recommendationsConfigs
        self.documentInstructionsConfigs = documentInstructionsConfigs
        
        super.init()
    }
    
    
    public static func `default`() -> VerifieTextConfigs {
        
        let defaultConfigs = VerifieTextConfigs(movePhoneCloser: "Move phone closer".localized(),
                                                movePhoneAway: "Move phone away".localized(),
                                                holdStill: "Hold still".localized(),
                                                faceFailed: "Light face evenly".localized(),
                                                eyesFailed: "Light face evenly".localized(),
                                                detectionFailed: "Face detection has been failed, please try again later.".localized())
        
        return defaultConfigs
    }
}
