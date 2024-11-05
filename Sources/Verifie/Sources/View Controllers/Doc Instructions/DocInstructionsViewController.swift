//
//  DocInstructionsViewController.swift
//  Verifie
//
//  Created by Misha Torosyan on 12/3/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

final class DocInstructionsViewController: VerifieBaseViewController,
                                            VerifieDocInstructionsViewControllerInterface {
    
    //    MARK: - Private Members
    @IBOutlet private weak var bgImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var documentImageView: UIImageView!
    @IBOutlet private weak var continueButton: UIButton!
    
    //    MARK: - Internal Members
    weak var actionsDelegate: DocInstructionsViewControllerActionsDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .default
    }
    
    
    //    MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //    MARK: - Internal Functions
    func update(with textConfigs: VerifieDocInstructionsTextConfigs,
                documentType: VerifieDocumentType) {
        
        
        titleLabel.text = textConfigs.instructionTitle
        subtitleLabel.text = textConfigs.instructionSubtitle
        continueButton.layer.cornerRadius = 8
        continueButton.layer.masksToBounds = true
        continueButton.setTitle(textConfigs.continueButtonTitle, for: .normal)
        
        switch documentType {
        case .passport:
            documentImageView.image = UIImage(named: "doc_instructions_passport",
                                              in: Bundle.sources(),
                                              compatibleWith: nil)
        default:
            documentImageView.image = UIImage(named: "doc_instructions_card",
                                              in: Bundle.sources(),
                                              compatibleWith: nil)
        }
    }
    
    //    MARK: - Action Functions
    @IBAction func continueButtonAction(_ sender: UIButton) {
        
        actionsDelegate?.didPressContinueDocInstructionsViewController(self)
    }
    
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        
        actionsDelegate?.didPressCloseDocInstructionsViewController(self)
    }
}
