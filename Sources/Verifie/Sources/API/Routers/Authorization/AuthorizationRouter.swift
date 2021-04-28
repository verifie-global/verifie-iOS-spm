//
//  AuthorizationRouter.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/7/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire

enum AuthorizationRouter: APIRouter {
    
    case accessToken(licenseKey: String, personId: String?)
    
    static let baseURLString = K.ProductionServer.baseURL
    
    var method: HTTPMethod {
        switch self {
        case .accessToken:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .accessToken:
            return K.APIUrlPath.accessToken
        }
    }
    
    var queryParameters: Parameters? {
        
        switch self {
        case .accessToken(let licenseKey, let personId):
            if let personId = personId {
                return [K.APIParameterKey.licenseKey: licenseKey, K.APIParameterKey.personId: personId]
            }
            else {
                return [K.APIParameterKey.licenseKey: licenseKey]
            }
        }
    }
    
    var bodyParameters: Parameters? {
        
        switch self {
        default:
            return nil
        }
    }
    
    var contentType: ContentType? {
        
        switch self {
        case .accessToken:
            return .json
        }
    }
}
