//
//  ProgressHUD.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/14/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation
import MBProgressHUD

class ProgressHUD {
    
    static func show(in view: UIView?) {
        
        guard let view = view else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    static func hide(from view: UIView?) {
        
        guard let view = view else { return }
        MBProgressHUD.hide(for: view, animated: true)
    }
}
