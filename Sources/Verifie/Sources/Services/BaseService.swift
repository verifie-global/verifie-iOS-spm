//
//  BaseService.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/7/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

class BaseService {
    
    let apiManager: APIManager
    
    required init(apiManager: APIManager) {
        
        self.apiManager = apiManager
    }
}
