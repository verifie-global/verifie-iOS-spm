//
//  DocScannerSceneHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 7/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

protocol DocScannerSceneHandlerDelegate: class {
    
    func docScannerSceneHandlerDidReceiveCloseAction(_ sender: DocScannerSceneHandler)
}

final class DocScannerSceneHandler: SceneHandler {
    
    let viewController: VerifieDocScannerViewControllerInterface
    
    weak var delegate: DocScannerSceneHandlerDelegate?
    
    
    //    MARK: - Initializers
    required init?(viewController: VerifieViewControllerInterface) {
        
        guard
            let viewController = viewController as? VerifieDocScannerViewControllerInterface else {
                return nil
        }
        
        self.viewController = viewController
        
        super.init(viewController: viewController)
        
        viewController.actionsDelegate = self
    }
}

extension DocScannerSceneHandler: DocScannerViewControllerActionsDelegate {
    
    func didPressCloseButtonDocScannerViewController(_
        sender: VerifieDocScannerViewControllerInterface) {
        
        delegate?.docScannerSceneHandlerDidReceiveCloseAction(self)
    }
}
