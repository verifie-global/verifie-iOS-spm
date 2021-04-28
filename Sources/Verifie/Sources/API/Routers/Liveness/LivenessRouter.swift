//
//  LivenessRouter.swift
//  Verifie
//
//  Created by Misha Torosyan on 7/1/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import Alamofire

enum LivenessRouter: APIRouter {
    
    static var baseURLString = K.ProductionServer.baseURL
    
    case liveness(imageData: String)
    
    var method: HTTPMethod {
        switch self {
        case .liveness:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .liveness:
            return K.APIUrlPath.liveness
        }
    }
    
    var queryParameters: Parameters? {
        
        switch self {
        default:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        
        switch self {
        case .liveness(let imageData):
            return [
                K.APIParameterKey.image: imageData
            ]
        }
    }
    
    var contentType: ContentType? {
        
        switch self {
        case .liveness:
            return .json
        }
    }
}

