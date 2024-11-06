//
//  RecommendationsViewController.swift
//  Verifie
//
//  Created by Misha Torosyan on 11/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

final class RecommendationsViewController: VerifieBaseViewController, VerifieRecommendationsViewControllerInterface {
    
    internal weak var videoPreviewView: VerifieVideoSessionPreviewView!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var greatLabel: UILabel!
    @IBOutlet private weak var greatC: UIView!
    @IBOutlet private weak var noGlassesLabel: UILabel!
    @IBOutlet weak var noGlassesC: UIView!
    @IBOutlet private weak var noShadowLabel: UILabel!
    @IBOutlet weak var noShadowC: UIView!
    @IBOutlet private weak var noFlashLabel: UILabel!
    @IBOutlet weak var noFlashC: UIView!
    @IBOutlet private weak var continueButton: UIButton!
    
    weak var actionsDelegate: RecommendationsViewControllerActionsDelegate?
    

    //    MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //    MARK: - Internal Functions
    func update(_ textConfigs: VerifieRecommendationsTextConfigs) {
        print("JJ2 \(textConfigs)")
        title = textConfigs.title
        
        image1.layer.zPosition = 1
        
        subtitleLabel.text = textConfigs.subtitle
        greatLabel.text = textConfigs.great
        noGlassesLabel.text = textConfigs.noGlasses
        noShadowLabel.text = textConfigs.noShadow
        noFlashLabel.text = textConfigs.noFlas
        
        greatC.layer.cornerRadius = 12
        greatC.layer.borderColor = UIColor(red: 141/255.0, green: 147/255.0, blue: 158/255.0, alpha: 1.0).cgColor
        greatC.layer.masksToBounds = true
        greatC.layer.borderWidth = 1
        
        noGlassesC.layer.cornerRadius = 12
        noGlassesC.layer.borderColor = UIColor(red: 141/255.0, green: 147/255.0, blue: 158/255.0, alpha: 1.0).cgColor
        noGlassesC.layer.masksToBounds = true
        noGlassesC.layer.borderWidth = 1
        
        noShadowC.layer.cornerRadius = 12
        noShadowC.layer.borderColor = UIColor(red: 141/255.0, green: 147/255.0, blue: 158/255.0, alpha: 1.0).cgColor
        noShadowC.layer.masksToBounds = true
        noShadowC.layer.borderWidth = 1
        
        noFlashC.layer.cornerRadius = 12
        noFlashC.layer.borderColor = UIColor(red: 141/255.0, green: 147/255.0, blue: 158/255.0, alpha: 1.0).cgColor
        noFlashC.layer.masksToBounds = true
        noFlashC.layer.borderWidth = 1

        continueButton.layer.cornerRadius = 8
        continueButton.layer.masksToBounds = true
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
