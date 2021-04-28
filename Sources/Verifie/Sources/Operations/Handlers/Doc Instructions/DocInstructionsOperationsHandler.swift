//
//  DocInstructionsOperationsHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 12/3/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

protocol DocInstructionsOperationsHandlerDelegate: OperationsHandlerDelegate {
    
    func docInstructionsOperationsHandlerDidReceiveContinueAction(_
        sender: DocInstructionsOperationsHandler)
    
    func docInstructionsOperationsHandlerDidReceiveCloseAction(_
    sender: DocInstructionsOperationsHandler)
    
    func docInstructionsOperationsHandler(_ sender: DocInstructionsOperationsHandler,
                                          didFailWith error: VerifieError)
}

final class DocInstructionsOperationsHandler: OperationsHandler {
    
    //    MARK: - Private Members
    private var textConfigs: VerifieTextConfigs!
    private var viewController: VerifieDocInstructionsViewControllerInterface!
    private var documentScannerConfigs: VerifieDocumentScannerConfigs!
    
    //    MARK: - Internal Members
    weak var delegate: DocInstructionsOperationsHandlerDelegate?
    
    
    //    MARK: - Initializers
    required init(appSession: AppSession) {
        
        super.init(appSession: appSession)
    }
    
    
    //    MARK: - Internal Functions
    func start(_ textConfigs: VerifieTextConfigs,
               viewControllersConfigs: VerifieViewControllersConfigs?,
               documentScannerConfigs: VerifieDocumentScannerConfigs) {
        
        self.textConfigs = textConfigs
        self.documentScannerConfigs = documentScannerConfigs
        
        setup(with: viewControllersConfigs)
        
        guard let docInstructionsViewController = viewController
            as? VerifieBaseViewController else {
                
                handle(VerifieError.unhandledError(nil))
                return
        }
        
        docInstructionsViewController.lifeCycleDelegate = self
        appSession.uiManager.show(docInstructionsViewController)
    }
    
    
    //    MARK: - Private Functions
    private func setup(with viewControllersConfigs: VerifieViewControllersConfigs?) {
        
        if let viewController = viewControllersConfigs?.docInstructionsViewController {
            self.viewController = viewController
        }
        else {
            
            let viewController: DocInstructionsViewController = DocInstructionsViewController.load()
            self.viewController = viewController
        }
        
        viewController.actionsDelegate = self
    }
    
    private func start(with
        viewController: VerifieDocInstructionsViewControllerInterface,
                       textConfigs: VerifieDocInstructionsTextConfigs,
                       documentScannerConfigs: VerifieDocumentScannerConfigs) {
        
        
        viewController.update(with: textConfigs,
                              documentType: documentScannerConfigs.documentType)
    }
    
    
    private func handle(_ error: VerifieError) {
        
        delegate?.docInstructionsOperationsHandler(self, didFailWith: error)
    }
}

extension DocInstructionsOperationsHandler: VerifieBaseViewControllerDelegate {
    
    func viewControllerViewDidLoad(_ sender: VerifieBaseViewController) {
        
        guard let interface = sender as? VerifieDocInstructionsViewControllerInterface else {
            
            handle(VerifieError.unhandledError(nil))
            return
        }
        
        start(with: interface,
              textConfigs: textConfigs.documentInstructionsConfigs,
              documentScannerConfigs: documentScannerConfigs)
    }
}

 
extension DocInstructionsOperationsHandler: DocInstructionsViewControllerActionsDelegate {
    
    func didPressContinueDocInstructionsViewController(_
        sender: VerifieDocInstructionsViewControllerInterface) {
        
        delegate?.docInstructionsOperationsHandlerDidReceiveContinueAction(self)
    }
    
    func didPressCloseDocInstructionsViewController(_
        sender: VerifieDocInstructionsViewControllerInterface) {
        
        delegate?.docInstructionsOperationsHandlerDidReceiveCloseAction(self)
    }
}
