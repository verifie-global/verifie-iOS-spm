//
//  VerifieRecommendationsTextConfigs.swift
//  Verifie
//
//  Created by Misha Torosyan on 11/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objcMembers public class VerifieRecommendationsTextConfigs: NSObject {
    
    /// Title text. Defailt `Recommendations`
    public let title: String
    
    /// Title text. Defailt `Light face evenly`
    public let subtitle: String
    
    /// Recommendation text. Defailt `Great!`
    public let great: String
    
    /// Recommendation text. Defailt `No Glasses`
    public let noGlasses: String
    
    /// Recommendation text. Defailt `No Shadow`
    public let noShadow: String
    
    /// Recommendation text. Defailt `No Flash`
    public let noFlas: String
    
    /// Recommendation text. Defailt `Continue`
    public let continueText: String
    
    
    public init(title: String,
                subtitle: String,
                great: String,
                noGlasses: String,
                noShadow: String,
                noFlas: String,
                continueText: String) {
        
        self.title = title
        self.subtitle = subtitle
        self.great = great
        self.noGlasses = noGlasses
        self.noShadow = noShadow
        self.noFlas = noFlas
        self.continueText = continueText
        
        super.init()
    }
    
    public static func `default`() -> VerifieRecommendationsTextConfigs {
        
        let defaultConfigs = VerifieRecommendationsTextConfigs(title: "Recommendations".localized(),
                                                               subtitle: "Light face evenly".localized(),
                                                               great: "Great!".localized(),
                                                               noGlasses: "No Glasses".localized(),
                                                               noShadow: "No Shadow".localized(),
                                                               noFlas: "No Flash".localized(),
                                                               continueText: "Continue".localized())
        
        return defaultConfigs
    }
}
