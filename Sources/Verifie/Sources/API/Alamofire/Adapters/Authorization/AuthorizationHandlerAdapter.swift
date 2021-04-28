//
//  AuthorizationHandlerAdapter.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/7/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire
import Foundation

final class AuthorizationHandlerAdapter: RequestAdapter {
    
    private var accessToken: String?
    
    
    // MARK: - Internal Functions
    func set(_ accessToken: String) {
        
        self.accessToken = accessToken
    }
    
    
    // MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var urlRequest = urlRequest
        
        if let accessToken = accessToken {
            urlRequest.setValue(accessToken,
                                forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }
        
        completion(.success(urlRequest))
    }
}
