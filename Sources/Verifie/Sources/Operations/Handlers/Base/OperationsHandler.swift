//
//  OperationsHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/11/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

protocol OperationsHandlerDelegate: class {}

class OperationsHandler {
    
    //    MARK: - Members
    let appSession: AppSession
    
    
    //    MARK: - Initializers
    required init(appSession: AppSession) {
        
        self.appSession = appSession
    }
}
