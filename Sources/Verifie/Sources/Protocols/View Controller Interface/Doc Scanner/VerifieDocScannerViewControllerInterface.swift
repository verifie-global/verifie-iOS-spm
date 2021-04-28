//
//  VerifieDocScannerViewControllerInterface.swift
//  Verifie
//
//  Created by Misha Torosyan on 7/21/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

@objc public protocol DocScannerViewControllerActionsDelegate: class {
    
    func didPressCloseButtonDocScannerViewController(_
        sender: VerifieDocScannerViewControllerInterface)
}

@objc public protocol VerifieDocScannerViewControllerInterface: VerifieViewControllerInterface {
    
    var croppingAreaView: UIView! { get set }
    var videoPreviewView: VerifieVideoSessionPreviewView! { get set }
    var instructionsTitleLabel: UILabel! { get set }
    var instructionsSubtitleLabel: UILabel! { get set }
    var croppingAreaImageView: UIImageView! { get set }
    weak var actionsDelegate: DocScannerViewControllerActionsDelegate? { get set }
    
    func updateText(with textConigs: VerifieDocumentScannerTextConfigs,
                    documentType: VerifieDocumentType,
                    pageNumber: DocPageNumber)
}

