//
//  SecondDocInfoOperationsHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/6/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import Foundation

protocol SecondDocInfoOperationsHandlerDelegate: OperationsHandlerDelegate {
    
    func secondDocInfoOperationsHandlerDidReceiveContinueAction(_
        sender: SecondDocInfoOperationsHandler)
    
    func secondDocInfoOperationsHandlerDidReceiveCloseAction(_
    sender: SecondDocInfoOperationsHandler)
    
    func secondDocInfoOperationsHandler(_ sender: SecondDocInfoOperationsHandler,
                                          didFailWith error: VerifieError)
}

final class SecondDocInfoOperationsHandler: OperationsHandler {
    
    //    MARK: - Private Members
    private var viewController: VerifieSecondDocInfoViewControllerInterface!
    private var documentScannerConfigs: VerifieDocumentScannerConfigs!
    
    //    MARK: - Internal Members
    weak var delegate: SecondDocInfoOperationsHandlerDelegate?
    
    
    //    MARK: - Internal Functions
    func start(_ viewControllersConfigs: VerifieViewControllersConfigs?,
               documentScannerConfigs: VerifieDocumentScannerConfigs) {
        
        self.documentScannerConfigs = documentScannerConfigs
        
        setup(with: viewControllersConfigs)
    }
    
    
    //    MARK: - Private Functions
    private func setup(with viewControllersConfigs: VerifieViewControllersConfigs?) {
        
        if let viewController = viewControllersConfigs?.secondDocInfoViewController {
            
            guard let secondDocInfoViewController = viewController
                as? VerifieBaseViewController else {
                    
                    handle(VerifieError.unhandledError(nil))
                    return
            }
            
            secondDocInfoViewController.lifeCycleDelegate = self
            appSession.uiManager.show(secondDocInfoViewController)
            
            self.viewController = viewController
            viewController.actionsDelegate = self
        }
        else {
            delegate?.secondDocInfoOperationsHandlerDidReceiveContinueAction(self)
        }
        
    }
    
    private func start(with viewController: VerifieSecondDocInfoViewControllerInterface,
                       documentScannerConfigs: VerifieDocumentScannerConfigs) {
        
        
        viewController.update(documentType: documentScannerConfigs.documentType)
    }
    
    private func handle(_ error: VerifieError) {
        
        delegate?.secondDocInfoOperationsHandler(self, didFailWith: error)
    }
}


extension SecondDocInfoOperationsHandler: VerifieBaseViewControllerDelegate {
    
    func viewControllerViewDidLoad(_ sender: VerifieBaseViewController) {
        
        guard let interface = sender as? VerifieSecondDocInfoViewControllerInterface else {
            
            handle(VerifieError.unhandledError(nil))
            return
        }
        
        start(with: interface, documentScannerConfigs: documentScannerConfigs)
    }
}

 
extension SecondDocInfoOperationsHandler: SecondDocInfoViewControllerActionsDelegate {
    
    func didPressCloseSecondDocInfoViewController(_ sender: VerifieSecondDocInfoViewControllerInterface) {
        
        delegate?.secondDocInfoOperationsHandlerDidReceiveCloseAction(self)
    }
    
    func didPressContinueSecondDocInfoViewController(_ sender: VerifieSecondDocInfoViewControllerInterface) {
        
        delegate?.secondDocInfoOperationsHandlerDidReceiveContinueAction(self)
    }
}
