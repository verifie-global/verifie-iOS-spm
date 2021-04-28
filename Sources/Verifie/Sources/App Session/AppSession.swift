//
//  AppSession.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/7/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

final class AppSession {
    
    //    MARK: - Members
    let apiManager = APIManager()
    let servicesProvider = ServicesProvider()
    let uiManager = UIManager()
    
    
    //    MARK: - Initializers
    init(verifieConfigs: VerifieConfigs) {
        
        updateApiManager(with: verifieConfigs)
    }
    
    
    //    MARK: - Private Functions
    private func updateApiManager(with verifieConfigs: VerifieConfigs) {
        
        apiManager.add(headerValue: verifieConfigs.languageCode,
                       forHTTPHeaderField: HTTPHeaderField.language.rawValue)
    }
}
