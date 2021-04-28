//
//  Verifie.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/8/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

@objcMembers final public class Verifie: NSObject, VerifieProtocol {
    
    //    MARK: Private Members
    private let configs: VerifieConfigs!
    private let appSession: AppSession!
    private var operationsManager: OperationsManager!
    private weak var delegate: VerifieDelegate?
    
    
    //    MARK: - Initialiers
    required public init(configs: VerifieConfigs, delegate: VerifieDelegate) {
        
        self.configs = configs
        self.appSession = AppSession(verifieConfigs: configs)
        self.operationsManager = OperationsManager(appSession: appSession, configs: configs)
        self.delegate = delegate
        
        super.init()
        
        appSession.uiManager.delegate = self
        operationsManager.delegate = self
    }
    
    private override init() {
        
        self.configs = nil
        self.appSession = nil
        
        super.init()
        
        self.handle(.unhandledError(nil))
    }
    
    
    //    MARK: - Private Functions
    private func validate(_ licenseKey: String, personId: String?) {
        
        operationsManager.start(licenseKey: licenseKey, personId: personId)
    }
    
    private func handle(_ error: VerifieError) {
        
        delegate?.verifie(self, didFailWith: error)
    }
    
    private func handle(_ document: VerifieDocument) {
        
        delegate?.verifie(self, didReceive: document)
    }
    
    private func handle(_ score: VerifieScore) {
        
        delegate?.verifie(self, didCalculate: score)
    }
    
    private func handle(_ liveness: VerifieLiveness) {
        
        delegate?.verifie(self, didCheck: liveness)
    }
    
    
    //    MARK: Public Functions
    public func start() {
        
        validate(configs.licenseKey, personId: configs.personId)
    }
    
    public func stop() {
        
        operationsManager.stop()
    }
}


extension Verifie: UIManagerDelegate {
    
    func viewControllerToPresent(_ sender: UIManager) -> UIViewController? {
        
        guard let viewController = delegate?.viewControllerToPresent(self) else {
            
            handle(.missingViewController)
            return nil
        }
        
        return viewController
    }
}


extension Verifie: OperationsManagerDelegate {
    
    func operationsManager(_ sender: OperationsManager, didReceive error: VerifieError) {
        
        handle(error)
    }
    
    func operationsManager(_ sender: OperationsManager, didReceive document: VerifieDocument) {
        
        handle(document)
    }
    
    func operationsManager(_ sender: OperationsManager, didCalculate score: VerifieScore) {
        
        handle(score)
    }
    
    func operationsManager(_ sender: OperationsManager, didCheck liveness: VerifieLiveness) {
        
        handle(liveness)
    }
    
    func operationsManagerDidStopOperations(_ sender: OperationsManager) {
        
        delegate?.verifieDidFinish(self)
    }
}
