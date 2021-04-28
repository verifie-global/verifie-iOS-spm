//
//  APIActivityIndicatorManager.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/14/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire
import UIKit

class APIActivityIndicatorManager {
    
    //    MARK: - Members
    private var skippingRequests: [Request] = []
    
    
    //    MARK: - Lifcecycle Functions
    init() {
        registerForNotifications()
    }
    
    deinit {
        unregisterForNotifications()
    }
    
    
    //    MARK: - Internal Functions
    func skip(request: Request) {
        
        skippingRequests.append(request)
    }

    // MARK: - Private Functions
    // MARK: Notification Registration
    private func registerForNotifications() {
        
        unregisterForNotifications()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(APIActivityIndicatorManager.networkRequestDidStart),
            name: Request.didResumeTaskNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(APIActivityIndicatorManager.networkRequestDidStop),
            name: Request.didSuspendTaskNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(APIActivityIndicatorManager.networkRequestDidStop),
            name: Request.didCompleteTaskNotification,
            object: nil
        )
    }
    
    private func unregisterForNotifications() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Request.didResumeTaskNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Request.didCompleteTaskNotification,
                                                  object: nil)
    }
    
    
    // MARK: Notifications
    @objc private func networkRequestDidStart(notification: Notification) {
        
        guard let request = notification.request else { return }
        
        if (!skippingRequests.contains(request)) {
            ProgressHUD.show(in: UIApplication.shared.keyWindow)
        }
    }
    
    @objc private func networkRequestDidStop(notification: Notification) {
        
        guard let request = notification.request else { return }
        skippingRequests.removeAll(where: {$0 == request})
        
        ProgressHUD.hide(from: UIApplication.shared.keyWindow)
    }
}
