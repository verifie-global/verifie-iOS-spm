//
//  MainViewController.swift
//  VerifieFramework
//
//  Created by Misha Torosyan on 12/1/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let viewController: DocumentTypeViewController = DocumentTypeViewController.load()
            self.navigationController?.setViewControllers([viewController], animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

public enum Storyboard: String {
    
    case main = "Main"
}

public extension UIViewController {
    
    static func load<T: UIViewController>(from storyboard: Storyboard = .main) -> T {
        
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: bundle)
        let selfName = String(describing: self)
        let viewController = storyboard.instantiateViewController(withIdentifier: selfName) as! T
        
        return viewController
    }
}

