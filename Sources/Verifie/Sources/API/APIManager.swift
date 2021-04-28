//
//  APIManager.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/7/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire

final class APIManager {
    
    private var session: Session!
    private let authHandlerAdapter = AuthorizationHandlerAdapter()
    private let additionalHeadersAdapter = AdditionalHeadersAdapter()
    private var interceptor: Interceptor!
    private let activityIndicatorManager = APIActivityIndicatorManager()
    
    //    MARK: - Initializers
    init() {
        setupManager()
    }
    
    
    //    MARK: - Private Methods
    private func setupManager() {
        
        setupInterceptor()
        setupSessionManager()
    }
    
    private func setupInterceptor() {
        
        let interceptor = Interceptor(
            adapters: [authHandlerAdapter, additionalHeadersAdapter],
            retriers: [RetryPolicy(retryLimit: 1)]
        )
        
        self.interceptor = interceptor
    }
    
    private func setupSessionManager() {
        
        #if DEBUG
        let eventMonitors = [AlamofireLogger()]
        #else
        let eventMonitors: [EventMonitor] = []
        #endif
        
        let session = Session(interceptor: interceptor, eventMonitors: eventMonitors)
        self.session = session
    }
    
    
    //    MARK: - Internal Methods
    func set(_ accessToken: String) {
        
        authHandlerAdapter.set(accessToken)
    }
    
    func add(headerValue value: String, forHTTPHeaderField field: String) {
        
        additionalHeadersAdapter.add(headerValue: value, forHTTPHeaderField: field)
    }
    
    func send(_ request: URLRequestConvertible, showLoading: Bool = true) -> DataRequest {
        
        let request = session.request(request)
        
        if (!showLoading) {
            activityIndicatorManager.skip(request: request)
        }
        
        return request
    }
    
}
