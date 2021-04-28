//
//  SceneHandlerFactory.swift
//  Verifie
//
//  Created by Misha Torosyan on 7/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

class SceneHandlerFactory {
    
    class func scene<T: SceneHandler>(_ viewController: VerifieViewControllerInterface) -> T? {
        
        let sceneHandler = T(viewController: viewController)
        
        return sceneHandler
    }
}
