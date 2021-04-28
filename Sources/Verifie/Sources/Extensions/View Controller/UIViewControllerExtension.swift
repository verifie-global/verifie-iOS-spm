//
//  VerifieUIViewControllerExtension.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

enum Storyboard: String {
    
    case verifie = "Verifie"
}

extension UIViewController {
    
    static func load<T: UIViewController>(from storyboard: Storyboard = .verifie) -> T {
        
        let bundle = Bundle.sources()
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: bundle)
        let selfName = String(describing: self)
        let viewController = storyboard.instantiateViewController(withIdentifier: selfName) as! T
        
        return viewController
    }
}
