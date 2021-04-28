//
//  APIRouter.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/7/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire
import Foundation

protocol APIRouter: URLRequestConvertible {
    
    static var baseURLString: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var queryParameters: Parameters? { get }
    var bodyParameters: Parameters? { get }
    var contentType: ContentType { get }
}

extension APIRouter {

    var contentType: ContentType {
        return .json
    }
}

extension APIRouter {
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try AuthorizationRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.addValue(contentType.rawValue,
                            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if let queryParameters = queryParameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        if let bodyParameters = bodyParameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters,
                                                                 options: .prettyPrinted)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
