//
//  Constants.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/7/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

struct K {
    
    struct ProductionServer {
        
        static let baseURL = "https://api.verifie.global"
    }
    
    struct APIUrlPath {
        
        static let accessToken = "/api/Main/AccessToken"
        static let document = "/api/Main/Document"
        static let score = "/api/Main/Score"
        static let liveness = "/api/Main/Liveness"
    }
    
    struct APIParameterKey {
        
        /// AccessToken
        static let licenseKey = "LicenseKey"
        static let personId = "PersonID"
        
        
        /// Document
        static let documentImage = "DocumentImage"
        
        
        /// Score
        static let selfieImage = "SelfieImage"
        
        
        /// Liveness Check
        static let image = "Image"
    }
}


enum HTTPHeaderField: String {
    
    case authorization = "Authorization"
    case language = "Lang"
    case contentType = "Content-Type"
}

enum ContentType: String {
    
    case json = "application/json"
}
