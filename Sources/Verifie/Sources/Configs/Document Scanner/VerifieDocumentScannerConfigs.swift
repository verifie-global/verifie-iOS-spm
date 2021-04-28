//
//  VerifieDocumentScannerConfigs.swift
//  Verifie
//
//  Created by Misha Torosyan on 9/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objcMembers public class VerifieDocumentScannerConfigs: NSObject {
    
    @objc public enum ScannerOrientation: Int {
        
        case portrait
        case landscape
    }
    
    /// Document scanner's orientation
    public let scannerOrientation: ScannerOrientation
    
    /// Document type that should scan the scanner. Default `.unknown`
    public let documentType: VerifieDocumentType

    public init(scannerOrientation: ScannerOrientation,
                documentType: VerifieDocumentType = .unknown) {
        
        self.scannerOrientation = scannerOrientation
        self.documentType = documentType
        
        super.init()
    }
    
    public static func `default`() -> VerifieDocumentScannerConfigs {
        
        let defaultConfigs = VerifieDocumentScannerConfigs(scannerOrientation: .portrait)
        
        return defaultConfigs
    }
}
