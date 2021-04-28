//
//  RecommendationsSceneHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 11/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

protocol RecommendationsSceneHandlerDelegate: class {
        
    func recommendationsSceneHandlerDidReceiveCloseAction(_ sender: RecommendationsSceneHandler)
    
    func recommendationsSceneHandlerDidReceiveContinueAction(_ sender: RecommendationsSceneHandler)
}

final class RecommendationsSceneHandler: SceneHandler {
    
    let viewController: VerifieRecommendationsViewControllerInterface
    
    weak var delegate: RecommendationsSceneHandlerDelegate?
    
    //    MARK: - Initializers
    required init?(viewController: VerifieViewControllerInterface) {
        
        guard
            let viewController = viewController as? VerifieRecommendationsViewControllerInterface else {
                return nil
        }
        
        self.viewController = viewController
        
        super.init(viewController: viewController)
        
        viewController.actionsDelegate = self
    }
}

extension RecommendationsSceneHandler: RecommendationsViewControllerActionsDelegate {
    
    func didPressCloseRecommendationsViewController(_ sender: VerifieRecommendationsViewControllerInterface) {
        
        delegate?.recommendationsSceneHandlerDidReceiveCloseAction(self)
    }
    
    func didPressContinueButtonRecommendationsViewController(_ sender: VerifieRecommendationsViewControllerInterface) {
        
        delegate?.recommendationsSceneHandlerDidReceiveContinueAction(self)
    }
}
