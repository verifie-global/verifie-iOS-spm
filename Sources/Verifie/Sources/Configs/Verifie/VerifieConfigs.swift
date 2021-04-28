//
//  VerifieConfigs.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/15/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objcMembers public class VerifieConfigs: NSObject {
    
    /// License key for authorization
    public let licenseKey: String
    
    /// Person unique Id for identification
    public let personId: String?
    
    /// Language ISO code. Default `ENG`
    public let languageCode: String
    
    /// Checks only user's liveness and skips other steps. Default `false`
    public let livenessCheck: Bool
    
    /// Visible texts configuration
    public let textConfigs: VerifieTextConfigs
    
    /// Colors configuration
    public let colorConfigs: VerifieColorConfigs
    
    // Config for view controllers customization
    public let viewControllersConfigs: VerifieViewControllersConfigs?
    
    /// Configurations for document scanner
    public let documentScannerConfigs: VerifieDocumentScannerConfigs
    
    
    private override init() {
        
        self.licenseKey = ""
        self.personId = nil
        self.languageCode = ""
        self.livenessCheck = false
        self.textConfigs = VerifieTextConfigs.default()
        self.colorConfigs = VerifieColorConfigs.default()
        self.viewControllersConfigs = nil
        self.documentScannerConfigs = VerifieDocumentScannerConfigs.default()
    }
    
    public init(licenseKey: String,
                personId: String? = nil,
                languageCode: String = "ENG",
                livenessCheck: Bool = false,
                textConfigs: VerifieTextConfigs = VerifieTextConfigs.default(),
                colorConfigs: VerifieColorConfigs = VerifieColorConfigs.default(),
                viewControllersConfigs: VerifieViewControllersConfigs?,
                documentScannerConfigs: VerifieDocumentScannerConfigs
                                                        = VerifieDocumentScannerConfigs.default()) {
        
        self.licenseKey = licenseKey
        self.personId = personId
        self.languageCode = languageCode
        self.livenessCheck = livenessCheck
        self.textConfigs = textConfigs
        self.colorConfigs = colorConfigs
        self.viewControllersConfigs = viewControllersConfigs
        self.documentScannerConfigs = documentScannerConfigs
        
        super.init()
    }
}
