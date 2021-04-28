//
//  ProgressHUD.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/14/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation
import JGProgressHUD

class ProgressHUD {
    
    static func show(in view: UIView?) {
        
        guard let view = view else { return }
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
    }
    
    static func hide(from view: UIView?) {
        
        guard let view = view else { return }
        for hud in JGProgressHUD.allProgressHUDs(in: view) {
            hud.dismiss()
        }
    }
}
