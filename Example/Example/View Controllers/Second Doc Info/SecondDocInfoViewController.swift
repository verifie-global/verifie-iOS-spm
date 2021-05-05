//
//  SecondDocInfoViewController.swift
//  VerifieFramework
//
//  Created by Misha Torosyan on 5/6/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import UIKit
import Verifie

class SecondDocInfoViewController: VerifieBaseViewController, VerifieSecondDocInfoViewControllerInterface {
    
    var actionsDelegate: SecondDocInfoViewControllerActionsDelegate?
        
    func update(documentType: VerifieDocumentType) {
        
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        
        actionsDelegate?.didPressCloseSecondDocInfoViewController(self)
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        
        actionsDelegate?.didPressContinueSecondDocInfoViewController(self)
    }
}
