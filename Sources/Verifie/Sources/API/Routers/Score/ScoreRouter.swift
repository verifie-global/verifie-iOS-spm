//
//  ScoreRouter.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire

enum ScoreRouter: APIRouter {
    
    static var baseURLString = K.ProductionServer.baseURL
    
    case score(imageData: String)
    
    var method: HTTPMethod {
        switch self {
        case .score:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .score:
            return K.APIUrlPath.score
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
        case .score(let imageData):
            return [
                K.APIParameterKey.selfieImage: imageData
            ]
        }
    }
    
    var contentType: ContentType? {
        
        switch self {
        case .score:
            return .json
        }
    }
}
