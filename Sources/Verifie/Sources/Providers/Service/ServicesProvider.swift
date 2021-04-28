//
//  ServicesProvider.swift
//  Core
//
//  Created by Misha Torosyan on 6/26/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

final class ServicesProvider {
    
    private var services: [BaseService] = []
    
    init() {
        
    }
    
    func getService<T: BaseService>(apiManager: APIManager) -> T {
        
        var selectedService: T
        
        let service = services.first { (service) -> Bool in
            
            var status = false
            if let _ = service as? T {
                status = true
            }
            
            return status
        }
        
        if let service = service as? T {
            selectedService = service
        }
        else {
            
            let service = T(apiManager: apiManager)
            
            services.append(service)
            selectedService = service
        }
        
        return selectedService
    }
}
