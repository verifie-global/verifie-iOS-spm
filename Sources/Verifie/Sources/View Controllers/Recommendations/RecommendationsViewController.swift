//
//  RecommendationsViewController.swift
//  Verifie
//
//  Created by Misha Torosyan on 11/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

final class RecommendationsViewController: VerifieBaseViewController, VerifieRecommendationsViewControllerInterface {
    
    @IBOutlet weak var videoPreviewView: VerifieVideoSessionPreviewView! {
        didSet {
            videoPreviewView.autorotate = false
        }
    }
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var greatLabel: UILabel!
    @IBOutlet private weak var noGlassesLabel: UILabel!
    @IBOutlet private weak var noShadowLabel: UILabel!
    @IBOutlet private weak var noFlashLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    weak var actionsDelegate: RecommendationsViewControllerActionsDelegate?
    

    //    MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //    MARK: - Internal Functions
    func update(_ textConfigs: VerifieRecommendationsTextConfigs) {
        
        title = textConfigs.title
        subtitleLabel.text = textConfigs.subtitle
        greatLabel.text = textConfigs.great
        noGlassesLabel.text = textConfigs.noGlasses
        noShadowLabel.text = textConfigs.noShadow
        noFlashLabel.text = textConfigs.noFlas
        continueButton.setTitle(textConfigs.continueText, for: .normal)
    }
    
    
    //    MARK: Action Functions
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        
        actionsDelegate?.didPressCloseRecommendationsViewController(self)
    }
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        
        actionsDelegate?.didPressContinueButtonRecommendationsViewController(self)
    }
}
