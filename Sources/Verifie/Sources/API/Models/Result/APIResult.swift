//
//  APIResult.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/7/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

struct APIResult<T: Codable>: Codable {
    
    let opCode: Int
    let opDesc: String?
    let result: T?
    let validation: [VerifieValidation]?
}

extension APIResult {
    
    var isSuccess: Bool {
        
        let isSuccess = opCode == 0
        return isSuccess
    }
    
    
    var error: VerifieAPIResponseError {

        let error = VerifieAPIResponseError(code: opCode, desc: opDesc)
        return error
    }
}


