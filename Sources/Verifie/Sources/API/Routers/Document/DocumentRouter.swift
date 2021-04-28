//
//  DocumentRouter.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/11/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire

enum DocumentRouter: APIRouter {
    
    static var baseURLString = K.ProductionServer.baseURL
    
    case document(imageData: String)
    
    var method: HTTPMethod {
        switch self {
        case .document:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .document:
            return K.APIUrlPath.document
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
        case .document(let imageData):
            return [
                K.APIParameterKey.documentImage: imageData,
            ]
        }
    }
    
    var contentType: ContentType? {
        
        switch self {
        case .document:
            return .json
        }
    }
}
