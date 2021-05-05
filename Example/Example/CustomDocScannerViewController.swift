//
//  CustomDocScannerViewController.swift
//  Verifie
//
//  Created by Misha Torosyan on 7/27/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit
import Verifie

@objc(CustomDocScannerViewController)

@objcMembers class CustomDocScannerViewController: VerifieBaseViewController,
                                                    VerifieDocScannerViewControllerInterface {
    
    @IBOutlet weak var videoPreviewView: VerifieVideoSessionPreviewView! {
        didSet {
            videoPreviewView.autorotate = false
        }
    }

    @IBOutlet weak var croppingAreaView: UIView!
    @IBOutlet weak var instructionsTitleLabel: UILabel!
    @IBOutlet weak var instructionsSubtitleLabel: UILabel!
    @IBOutlet weak var instructionsContainerView: UIView!
    @IBOutlet weak var croppingAreaImageView: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
    
    weak var actionsDelegate: DocScannerViewControllerActionsDelegate?


    //    MARK: Overrided Functions
    override func viewDidLoad() {

        super.viewDidLoad()
        
        setupSubviews()
    }


    //    MARK: - Internal Functions
    func update(frame color: UIColor) {

        croppingAreaImageView.tintColor = color
        instructionsTitleLabel.textColor = color
//        instructionsSubtitleLabel.textColor = color
    }
    
    func updateText(with textConigs: VerifieDocumentScannerTextConfigs,
                    documentType: VerifieDocumentType,
                    pageNumber: DocPageNumber) {
        
    }


    //    MARK: - Private Functions
    private func setupSubviews() {

        instructionsContainerView.transform = CGAffineTransform(rotationAngle: .pi/2)
    }
    

    //    MARK: Action Functions
    @IBAction private func captureButtonAction(_ sender: Any) {

    }
}
