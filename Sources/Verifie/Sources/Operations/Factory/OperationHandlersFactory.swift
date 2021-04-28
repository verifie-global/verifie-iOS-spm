//
//  OperationHandlersFactory.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/11/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

class OperationHandlersFactory {
    
    static func handler<T: OperationsHandler>(appSession: AppSession) -> T {
        
        return T(appSession: appSession)
    }
}
