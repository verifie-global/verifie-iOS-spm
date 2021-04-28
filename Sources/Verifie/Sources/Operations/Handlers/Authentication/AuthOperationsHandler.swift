//
//  AuthOperationsHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/11/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

protocol AuthOperationsHandlerDelegate: OperationsHandlerDelegate {
    
    func authOperationsHandler(_ sender: AuthOperationsHandler,
                               didAuthorizeLicenseKey licenseKey: String,
                               personId: String?)
    
    func authOperationsHandler(_ sender: AuthOperationsHandler, didFailWith error: VerifieError)
}

final class AuthOperationsHandler: OperationsHandler {
    
    //    MARK: - Internal Members
    weak var delegate: AuthOperationsHandlerDelegate?
    
    
    //    MARK: - Internal Functions
    func authorize(licenseKey: String, personId: String?) {
        
        let mainService: MainService = appSession
            .servicesProvider
            .getService(apiManager: appSession.apiManager)
        
        mainService
            .authorize(licenseKey,
                       personId: personId) { [weak self]
                        (result: Result<VerifieAccessToken, VerifieError>) in
                        
                        guard let weakSelf = self else {
                            return
                        }
                        
                        switch result {
                        case .success(let accessToken):
                            weakSelf.licenseKeyVerified(accessToken,
                                                        licenseKey: licenseKey,
                                                        personId: personId)
                        case .failure(let error):
                            weakSelf.handle(error)
                        }
        }
    }
    
    
    //    MARK: - Private Functions
    private func licenseKeyVerified(_ acessToken: VerifieAccessToken,
                                    licenseKey: String,
                                    personId: String?) {
        
        appSession.apiManager.set(acessToken.accessToken)
        delegate?.authOperationsHandler(self,
                                        didAuthorizeLicenseKey: licenseKey,
                                        personId: personId)
    }
    
    private func handle(_ error: VerifieError) {
        
        delegate?.authOperationsHandler(self, didFailWith: error)
    }
}
