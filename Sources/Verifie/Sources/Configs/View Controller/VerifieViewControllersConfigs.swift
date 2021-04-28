//
//  VerifieViewControllersConfigs.swift
//  Verifie
//
//  Created by Misha Torosyan on 7/27/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objcMembers public class VerifieViewControllersConfigs: NSObject {
    
    /// Document scanner view controller
    public let documentScannerViewController: VerifieDocScannerViewControllerInterface?
    
    /// Human Detector view controller
    public let humanDetectorViewController: VerifieHumanDetectorViewControllerInterface?
    
    /// Recommendations view controller
    public let recommendationsViewController: VerifieRecommendationsViewControllerInterface?
    
    /// Document Instructions view controller
    public let docInstructionsViewController: VerifieDocInstructionsViewControllerInterface?
    
    /// Second Document Info view controller
    public let secondDocInfoViewController: VerifieSecondDocInfoViewControllerInterface?
    
    
    public init(documentScannerViewController: VerifieDocScannerViewControllerInterface?,
                humanDetectorViewController: VerifieHumanDetectorViewControllerInterface?,
                recommendationsViewController: VerifieRecommendationsViewControllerInterface?,
                docInstructionsViewController: VerifieDocInstructionsViewControllerInterface?,
                secondDocInfoViewController: VerifieSecondDocInfoViewControllerInterface?) {
        
        self.documentScannerViewController = documentScannerViewController
        self.humanDetectorViewController = humanDetectorViewController
        self.recommendationsViewController = recommendationsViewController
        self.docInstructionsViewController = docInstructionsViewController
        self.secondDocInfoViewController = secondDocInfoViewController
        
        super.init()
    }
}
