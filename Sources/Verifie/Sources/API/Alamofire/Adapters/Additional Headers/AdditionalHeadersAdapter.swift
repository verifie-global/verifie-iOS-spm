//
//  AdditionalHeadersAdapter.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/17/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire
import Foundation

final class AdditionalHeadersAdapter: RequestAdapter {
    
    private var headers: Alamofire.HTTPHeaders = []
    
    
    // MARK: - Internal Functions
    func add(headerValue value: String, forHTTPHeaderField field: String) {
        
        headers.add(name: field, value: value)
    }
    
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var urlRequest = urlRequest
        
        headers.forEach { (header) in
            urlRequest.headers.update(header)
        }
        
        completion(.success(urlRequest))
    }
}
