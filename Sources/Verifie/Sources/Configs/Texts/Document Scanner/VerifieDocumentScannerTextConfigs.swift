//
//  VerifieDocumentScannerTextConfigs.swift
//  Verifie
//
//  Created by Misha Torosyan on 12/1/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objcMembers public class VerifieDocumentScannerTextConfigs: NSObject {
    
    /// Passport title text. Default `Passport`
    public let passportTitle: String
    
    /// Passport instruction title text. Default `Passport face page`
    public let passportInstructionsTitle: String
    
    /// Passport instruction subtitle text. Default `Position the page with your photo in the frame`
    public let passportInstructionsSubtitle: String
    
    
    /// Id Card title text. Default `National Identity Card`
    public let idCardTitle: String
    
    /// Id Card instruction title text. Default `Front of card`
    public let idCardFrontInstructionsTitle: String
    
    /// Id Card instruction title text. Default `Back of card`
    public let idCardBackInstructionsTitle: String
    
    /// Id Card instruction subtitle text. Default `Position the front of your card in the frame`
    public let idCardFrontInstructionsSubtitle: String
    
    /// Id Card instruction subtitle text. Default `Position the back of your card in the frame`
    public let idCardBackInstructionsSubtitle: String
    
    
    /// Permit Card title text. Default `Residence Permit Card`
    public let permitCardTitle: String
    
    /// Id Card instruction title text. Default `Front of permit`
    public let permitCardFrontInstructionsTitle: String
    
    /// Id Card instruction title text. Default `Back of permit`
    public let permitCardBackInstructionsTitle: String
    
    /// Id Card instruction subtitle text. Default `Position the front of your permit in the frame`
    public let permitCardFrontInstructionsSubtitle: String
    
    /// Id Card instruction subtitle text. Default `Position the back of your permit in the frame`
    public let permitCardBackInstructionsSubtitle: String
    

    /// Wrong document type text. Default `Wrong document type`
    public let wrongDocumentType: String
    
    
    public init(passportTitle: String,
                passportInstructionsTitle: String,
                passportInstructionsSubtitle: String,
                idCardTitle: String,
                idCardFrontInstructionsTitle: String,
                idCardBackInstructionsTitle: String,
                idCardFrontInstructionsSubtitle: String,
                idCardBackInstructionsSubtitle: String,
                permitCardTitle: String,
                permitCardFrontInstructionsTitle: String,
                permitCardBackInstructionsTitle: String,
                permitCardFrontInstructionsSubtitle: String,
                permitCardBackInstructionsSubtitle: String,
                wrongDocumentType: String) {
        
        self.passportTitle = passportTitle
        self.passportInstructionsTitle = passportInstructionsTitle
        self.passportInstructionsSubtitle = passportInstructionsSubtitle
        self.idCardTitle = idCardTitle
        self.idCardFrontInstructionsTitle = idCardFrontInstructionsTitle
        self.idCardBackInstructionsTitle = idCardBackInstructionsTitle
        self.idCardFrontInstructionsSubtitle = idCardFrontInstructionsSubtitle
        self.idCardBackInstructionsSubtitle = idCardBackInstructionsSubtitle
        self.permitCardTitle = permitCardTitle
        self.permitCardFrontInstructionsTitle = permitCardFrontInstructionsTitle
        self.permitCardBackInstructionsTitle = permitCardBackInstructionsTitle
        self.permitCardFrontInstructionsSubtitle = permitCardFrontInstructionsSubtitle
        self.permitCardBackInstructionsSubtitle = permitCardBackInstructionsSubtitle
        self.wrongDocumentType = wrongDocumentType
    }
    
    public static func `default`() -> VerifieDocumentScannerTextConfigs {
        
        let defaultConfigs = VerifieDocumentScannerTextConfigs(passportTitle: "passportTitle".localized(),
                                                               passportInstructionsTitle: "passportInstructionsTitle".localized(),
                                                               passportInstructionsSubtitle: "passportInstructionsSubtitle".localized(),
                                                               idCardTitle: "idCardTitle".localized(),
                                                               idCardFrontInstructionsTitle: "idCardFrontInstructionsTitle".localized(),
                                                               idCardBackInstructionsTitle: "idCardBackInstructionsTitle".localized(),
                                                               idCardFrontInstructionsSubtitle: "idCardFrontInstructionsSubtitle".localized(),
                                                               idCardBackInstructionsSubtitle: "idCardBackInstructionsSubtitle".localized(),
                                                               permitCardTitle: "Residence Permit Card".localized(),
                                                               permitCardFrontInstructionsTitle: "Front of permit".localized(),
                                                               permitCardBackInstructionsTitle: "Back of permit".localized(),
                                                               permitCardFrontInstructionsSubtitle: "Position the front of your permit in the frame".localized(),
                                                               permitCardBackInstructionsSubtitle: "Position the back of your permit in the frame".localized(),
                                                               wrongDocumentType: "Wrong document type".localized())
        
        return defaultConfigs
    }
}
