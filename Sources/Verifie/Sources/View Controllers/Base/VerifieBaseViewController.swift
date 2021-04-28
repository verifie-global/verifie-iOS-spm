//
//  VerifieBaseViewController.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

@objc public protocol VerifieBaseViewControllerDelegate: class {
    
    func viewControllerViewDidLoad(_ sender: VerifieBaseViewController)
}

@objcMembers open class VerifieBaseViewController: UIViewController,
                                                    VerifieViewControllerInterface {
    
    final public weak var lifeCycleDelegate: VerifieBaseViewControllerDelegate?
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        lifeCycleDelegate?.viewControllerViewDidLoad(self)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
}

