//
//  OperationsManager.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/11/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

protocol OperationsManagerDelegate: AnyObject {
    
    func operationsManager(_ sender: OperationsManager, didReceive error: VerifieError)
    
    func operationsManager(_ sender: OperationsManager, didReceive document: VerifieDocument)
    
    func operationsManager(_ sender: OperationsManager, didCalculate score: VerifieScore)
    
    func operationsManager(_ sender: OperationsManager, didCheck liveness: VerifieLiveness)
    
    func operationsManagerDidStopOperations(_ sender: OperationsManager)
}

final class OperationsManager {
    
    //    MARK: - Members
    private let appSession: AppSession
    
    private lazy var authOperationHandler: AuthOperationsHandler! = {
        
        let handler: AuthOperationsHandler
            = OperationHandlersFactory.handler(appSession: appSession)
        handler.delegate = self
        
        return handler
    }()
    
    private lazy var docScannerOperationsHandler: DocScannerOperationsHandler! = {
        
        let handler: DocScannerOperationsHandler
            = OperationHandlersFactory.handler(appSession: appSession)
        handler.delegate = self
        
        return handler
    }()
    
    private lazy var humanDetectorOperationsHandler: HumanDetectorOperationsHandler! = {
        
        let handler: HumanDetectorOperationsHandler
            = OperationHandlersFactory.handler(appSession: appSession)
        handler.delegate = self
        
        return handler
    }()
    
    private lazy var recommendationsOperationsHandler: RecommendationsOperationsHandler! = {
        
        let handler: RecommendationsOperationsHandler
            = OperationHandlersFactory.handler(appSession: appSession)
        handler.delegate = self
        
        return handler
    }()
    
    private lazy var docInstructionsOperationsHandler: DocInstructionsOperationsHandler! = {
        
        let handler: DocInstructionsOperationsHandler
            = OperationHandlersFactory.handler(appSession: appSession)
        handler.delegate = self
        
        return handler
    }()
    
    private lazy var secondDocInfoOperationsHandler: SecondDocInfoOperationsHandler! = {
        
        let handler: SecondDocInfoOperationsHandler
            = OperationHandlersFactory.handler(appSession: appSession)
        handler.delegate = self
        
        return handler
    }()
    
    private let configs: VerifieConfigs
    
    weak var delegate: OperationsManagerDelegate?

    
    //    MARK: - Initializers
    init(appSession: AppSession, configs: VerifieConfigs) {
        
        self.configs = configs
        self.appSession = appSession
    }
    
    
    //    MARK: - Internal Functions
    func start(licenseKey: String, personId: String?) {
        
        authOperationHandler.authorize(licenseKey: licenseKey, personId: personId)
    }
    
    func stop() {
        
        docScannerOperationsHandler.stop()
        humanDetectorOperationsHandler.stop()
        
        appSession.uiManager.hide { [weak self] in
            
            guard let self = self else { return }
            
            self.delegate?.operationsManagerDidStopOperations(self)
        }
    }
    
    
    //    MARK: - Private Functions
    private func handle(_ error: VerifieError) {
        
        switch error {
        case .wrongDocumentType:
            docScannerOperationsHandler.stop()
            appSession.uiManager.showAlert(title: configs.textConfigs.documentScannerConfigs.wrongDocumentType,
                                           message: "") { self.stop() }
        default:
            delegate?.operationsManager(self, didReceive: error)
            break
        }
    }
    
    
    //    MARK: Document Scanner
    private func startDocumentScannerOperations() {
        
        authOperationHandler = nil
        docScannerOperationsHandler.start(with: .first,
                                          textConfigs: configs.textConfigs,
                                          colorConfigs: configs.colorConfigs,
                                          viewControllersConfigs: configs.viewControllersConfigs,
                                          documentScannerConfigs: configs.documentScannerConfigs)
    }
    
    private func handle(sending image: UIImage, pageNumber: DocPageNumber) {
        
        let documentType = configs.documentScannerConfigs.documentType
        if (documentType == .idCard && pageNumber == .first) {
            startSecondDocInfoOperations()
        }
        else {
            startRecommendationsOperations()
        }
    }
    
    private func handle(_ document: VerifieDocument) {
        
        let documentType = configs.documentScannerConfigs.documentType
        if documentType == document.parsedDocumentType() {
            delegate?.operationsManager(self, didReceive: document)
        }
        else {
            handle(.wrongDocumentType)
        }
    }
    
    private func handle(_ score: VerifieScore) {
        
        delegate?.operationsManager(self, didCalculate: score)
    }
    
    private func handle(_ liveness: VerifieLiveness) {
        
        delegate?.operationsManager(self, didCheck: liveness)
    }
    
    
    //    MARK: Human Detector
    private func startHumanDetectorOperations() {
        
        humanDetectorOperationsHandler.start(configs.textConfigs,
                                             livenessCheck: configs.livenessCheck,
                                             viewControllersConfigs: configs.viewControllersConfigs)
    }
    
    
    //    MARK: Recommendations
    private func startRecommendationsOperations() {
        
        recommendationsOperationsHandler.start(configs.textConfigs,
                                               viewControllersConfigs: configs.viewControllersConfigs)
    }
    
    
    //    MARK: Document Instructions
    private func startDocInstructionsOperations() {
        
        docInstructionsOperationsHandler.start(configs.textConfigs,
                                               viewControllersConfigs: configs.viewControllersConfigs,
                                               documentScannerConfigs: configs.documentScannerConfigs)
    }
    
    
    // MARK: Second Documetn Info
    private func startSecondDocInfoOperations() {
        
        secondDocInfoOperationsHandler.start(configs.viewControllersConfigs,
                                             documentScannerConfigs: configs.documentScannerConfigs)
    }
}


extension OperationsManager: AuthOperationsHandlerDelegate {
    
    func authOperationsHandler(_ sender: AuthOperationsHandler,
                               didAuthorizeLicenseKey licenseKey: String,
                               personId: String?) {
        
        if (configs.livenessCheck) {
            startHumanDetectorOperations()
        }
        else {
            startDocInstructionsOperations()
        }
    }
    
    func authOperationsHandler(_ sender: AuthOperationsHandler, didFailWith error: VerifieError) {
        
        handle(error)
    }
}


extension OperationsManager: DocScannerOperationsHandlerDelegate {
    
    func docScannerOperationsHandler(_ sender: DocScannerOperationsHandler,
                                     didFailWith error: VerifieError) {
        
        handle(error)
    }
    
        func docScannerOperationsHandler(_ sender: DocScannerOperationsHandler,
                                         sending documentImage: UIImage,
                                         pageNumber: DocPageNumber) {
        DispatchQueue.main.async {
            self.handle(sending: documentImage, pageNumber: pageNumber)
        }
    }
    
    func docScannerOperationsHandler(_ sender: DocScannerOperationsHandler,
                                     didReceive document: VerifieDocument) {
        
        handle(document)
    }
    
    func docScannerOperationsHandlerDidReceiveStopAction(_ sender: DocScannerOperationsHandler) {
        
        stop()
    }
}


extension OperationsManager: HumanDetectorOperationsHandlerDelegate {
    
    func humanDetectorOperationsHandler(_ sender: HumanDetectorOperationsHandler,
                                        didCalculate score: VerifieScore) {
        handle(score)
    }
    
    func humanDetectorOperationsHandler(_ sender: HumanDetectorOperationsHandler,
                                        didCheck liveness: VerifieLiveness) {
        handle(liveness)
    }
    
    func humanDetectorOperationsHandler(_ sender: HumanDetectorOperationsHandler,
                                        didFailWith error: VerifieError) {
        handle(error)
    }
    
    func HumanDetectorOperationsHandlerDidReceiveStopAction(_
        sender: HumanDetectorOperationsHandler) {
        
        stop()
    }
}


extension OperationsManager: RecommendationsOperationsHandlerDelegate {
    
    func recommendationsOperationsHandlerDidReceiveStopAction(_
        sender: RecommendationsOperationsHandler) {
        
        stop()
    }
    
    func recommendationsOperationsHandlerDidReceiveContinueAction(_
        sender: RecommendationsOperationsHandler) {
        
        startHumanDetectorOperations()
    }
    
    func recommendationsOperationsHandler(_ sender: RecommendationsOperationsHandler,
                                          didFailWith error: VerifieError) {
        
        handle(error)
    }
}

extension OperationsManager: DocInstructionsOperationsHandlerDelegate {
    
    func docInstructionsOperationsHandlerDidReceiveCloseAction(_
        sender: DocInstructionsOperationsHandler) {
        
        stop()
    }
    
    
    func docInstructionsOperationsHandlerDidReceiveContinueAction(_
        sender: DocInstructionsOperationsHandler) {
        
        startDocumentScannerOperations()
    }
    
    func docInstructionsOperationsHandler(_ sender: DocInstructionsOperationsHandler,
                                          didFailWith error: VerifieError) {
        handle(error)
    }
}

extension OperationsManager: SecondDocInfoOperationsHandlerDelegate {
    
    func secondDocInfoOperationsHandlerDidReceiveContinueAction(_
        sender: SecondDocInfoOperationsHandler) {
        
        docScannerOperationsHandler.start(with: .second,
                                          textConfigs: configs.textConfigs,
                                          colorConfigs: configs.colorConfigs,
                                          viewControllersConfigs: configs.viewControllersConfigs,
                                          documentScannerConfigs: configs.documentScannerConfigs)
    }
    
    func secondDocInfoOperationsHandlerDidReceiveCloseAction(_
        sender: SecondDocInfoOperationsHandler) {
        stop()
    }
    
    func secondDocInfoOperationsHandler(_ sender: SecondDocInfoOperationsHandler,
                                        didFailWith error: VerifieError) {
        handle(error)
    }
}
