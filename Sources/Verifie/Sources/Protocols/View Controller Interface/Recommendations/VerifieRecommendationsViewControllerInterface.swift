//
//  VerifieRecommendationsViewControllerInterface.swift
//  Verifie
//
//  Created by Misha Torosyan on 11/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objc public protocol RecommendationsViewControllerActionsDelegate: class {
    
    func didPressCloseRecommendationsViewController(_
        sender: VerifieRecommendationsViewControllerInterface)
    
    func didPressContinueButtonRecommendationsViewController(_
        sender: VerifieRecommendationsViewControllerInterface)
}


@objc public protocol VerifieRecommendationsViewControllerInterface: VerifieViewControllerInterface {
    
    var videoPreviewView: VerifieVideoSessionPreviewView! { get set }
    weak var actionsDelegate: RecommendationsViewControllerActionsDelegate? { get set }
    
    
    func update(_ textConfigs: VerifieRecommendationsTextConfigs)
}

