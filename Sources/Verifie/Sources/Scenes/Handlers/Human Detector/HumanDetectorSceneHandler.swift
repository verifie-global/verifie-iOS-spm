//
//  HumanDetectorSceneHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 9/18/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

protocol HumanDetectorSceneHandlerDelegate: class {
    
    func humanDetectorSceneHandlerDidReceiveCloseAction(_ sender: HumanDetectorSceneHandler)
}

final class HumanDetectorSceneHandler: SceneHandler {
    
    let viewController: VerifieHumanDetectorViewControllerInterface
    
    weak var delegate: HumanDetectorSceneHandlerDelegate?
    
    
    //    MARK: - Initializers
    required init?(viewController: VerifieViewControllerInterface) {
        
        guard
            let viewController = viewController as? VerifieHumanDetectorViewControllerInterface else {
                return nil
        }
        
        
        self.viewController = viewController
        
        super.init(viewController: viewController)
        
        viewController.actionsDelegate = self
    }
}

extension HumanDetectorSceneHandler: HumanDetectorViewControllerActionsDelegate {
    
    func didPressCloseButtonHumanDetectorViewController(_
        sender: VerifieHumanDetectorViewControllerInterface) {
        
        delegate?.humanDetectorSceneHandlerDidReceiveCloseAction(self)
    }
}
