//
//  VerifieDocInstructionsTextConfigs.swift
//  Verifie
//
//  Created by Misha Torosyan on 12/3/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objcMembers public class VerifieDocInstructionsTextConfigs: NSObject {
    
    /// Instruction title text. Default `Scan Document`
    public let instructionTitle: String
    
    /// Instruction subtitle text. Default `Place your phone directly on top of your document as shown in the picture below.`
    public let instructionSubtitle: String
    
    /// Continue button title. Default `Continue`
    public let continueButtonTitle: String
    
    
    public init(instructionTitle: String,
                instructionSubtitle: String,
                continueButtonTitle: String) {
        
        self.instructionTitle = instructionTitle
        self.instructionSubtitle = instructionSubtitle
        self.continueButtonTitle = continueButtonTitle
    }
    
    public static func `default`() -> VerifieDocInstructionsTextConfigs {
        
        let defaultConfigs = VerifieDocInstructionsTextConfigs(instructionTitle: "Scan Document".localized(),
                                                               instructionSubtitle: "Place your phone directly on top of your document as shown in the picture below.".localized(),
                                                               continueButtonTitle: "Continue".localized())
        
        return defaultConfigs
    }
}
