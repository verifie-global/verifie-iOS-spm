//
//  UIManager.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

protocol UIManagerDelegate: AnyObject {
    
    func viewControllerToPresent(_ sender: UIManager) -> UIViewController?
}

final class UIManager: NSObject {
    
    //    MARK: - Members
    private lazy var rootNavigationController: RootNavigationController? = {
        
        let navigationController: RootNavigationController = RootNavigationController.load()
        
        return navigationController
    }()
    
    weak var delegate: UIManagerDelegate?
    private var sourceViewController: UIViewController?
    
    
    //    MARK: - Private Functions
    private func loadRootNavigationController(with rootViewController: UIViewController) {
        
        guard
            let sourceViewController = delegate?.viewControllerToPresent(self),
            let rootNavigationController = self.rootNavigationController else {
                return
        }
        
        rootNavigationController.modalPresentationStyle = .fullScreen
        
        if (sourceViewController != self.sourceViewController) {
            
            rootNavigationController.setViewControllers([rootViewController], animated: false)
            sourceViewController.present(rootNavigationController, animated: true, completion: nil)
            self.sourceViewController = sourceViewController
        }
    }
    
    
    
    //    MARK: - Internal Functions
    func show(_ viewController: UIViewController) {
        
        loadRootNavigationController(with: viewController)
        
        guard
            let rootNavigationController = self.rootNavigationController else {
                return
        }
        
        rootNavigationController.setViewControllers([viewController], animated: true)
    }
    
    func hide(completion: @escaping () -> Void) {

        if let presnetedViewController = rootNavigationController?.presentedViewController {
            presnetedViewController.dismiss(animated: true) {
                self.rootNavigationController?.dismiss(animated: true, completion: completion)
            }
        }
        else {
            rootNavigationController?.dismiss(animated: true, completion: completion)
        }
    }
    
    func showAlert(title: String?, message: String?, completion: (() -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(),
                                      style: .default){ _ in
                                        
                                        completion?()
        })
        
        rootNavigationController?.present(alert, animated: true, completion: nil)
    }
}
