//
//  DocScannerViewController.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

final class DocScannerViewController: VerifieBaseViewController,
                                        VerifieDocScannerViewControllerInterface {
    
    @IBOutlet weak var videoPreviewView: VerifieVideoSessionPreviewView! {
        didSet {
            videoPreviewView.autorotate = false
        }
    }
    
    @IBOutlet weak var backSide: UIImageView!
    @IBOutlet weak var croppingAreaView: UIView!
    @IBOutlet weak var instructionsTitleLabel: UILabel!
    @IBOutlet weak var instructionsSubtitleLabel: UILabel!
    @IBOutlet weak var croppingAreaImageView: UIImageView!
    @IBOutlet weak var croppingAreaAspectRatioConstraint: NSLayoutConstraint!
    
    weak var actionsDelegate: DocScannerViewControllerActionsDelegate?
    
    
    //    MARK: Overrided Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    
    //    MARK: - Internal Functions
    func update(frame color: UIColor) {
        
        croppingAreaImageView.tintColor = color
        instructionsTitleLabel.textColor = color
        instructionsSubtitleLabel.textColor = color
    }
    
    func updateText(with textConigs: VerifieDocumentScannerTextConfigs,
                    documentType: VerifieDocumentType,
                    pageNumber: DocPageNumber) {
        
        let navigationTitle: String
        let instructionsTitle: String
        let instructionsSubtitle: String
        
        switch documentType {
        case .passport:
            navigationTitle = textConigs.passportTitle
            instructionsTitle = textConigs.passportInstructionsTitle
            instructionsSubtitle = textConigs.passportInstructionsSubtitle
        case .idCard:
            navigationTitle = textConigs.idCardTitle
            instructionsTitle = (pageNumber == .first) ? textConigs.idCardFrontInstructionsTitle : textConigs.idCardBackInstructionsTitle
            instructionsSubtitle = (pageNumber == .first) ? textConigs.idCardFrontInstructionsSubtitle : textConigs.idCardBackInstructionsSubtitle
            
            if (pageNumber == .second) {
                backSide.alpha = 1
            }
        case .permitCard:
            navigationTitle = textConigs.permitCardTitle
            instructionsTitle = (pageNumber == .first) ? textConigs.permitCardFrontInstructionsTitle : textConigs.permitCardBackInstructionsTitle
            instructionsSubtitle = (pageNumber == .first) ? textConigs.permitCardFrontInstructionsSubtitle : textConigs.permitCardBackInstructionsSubtitle
        case .unknown:
            navigationTitle = "-"
            instructionsTitle = "-"
            instructionsSubtitle = "-"
        }
        
        title = navigationTitle
        instructionsTitleLabel.text = instructionsTitle
        instructionsSubtitleLabel.text = instructionsSubtitle
        updateCroppingAreaFrame(documentType: documentType)
    }
    
    
    //    MARK: - Private Functions
    private func updateCroppingAreaFrame(documentType: VerifieDocumentType) {
        
        if let croppingAreaView = croppingAreaView {
            
            let aspectRation: CGFloat
            
            switch documentType {
            case .passport:
                aspectRation = 1.4
            default:
                aspectRation = 1.58
            }
            
            let frameConstraint = NSLayoutConstraint(item: croppingAreaView,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: croppingAreaView,
                                                     attribute: .height,
                                                     multiplier: aspectRation,
                                                     constant: 0)
            
            croppingAreaView.removeConstraint(self.croppingAreaAspectRatioConstraint)
            croppingAreaView.addConstraint(frameConstraint)
            
            self.croppingAreaAspectRatioConstraint = frameConstraint
            
            view.layoutIfNeeded()
        }
    }

    //    MARK: Action Functions
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        
        actionsDelegate?.didPressCloseButtonDocScannerViewController(self)
    }
}
