//
//  BundleExtension.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objc public extension Bundle {
    
    static func sources() -> Bundle {
        
//        let bundle = Bundle(for: Verifie.self)
//
//        return bundle
        return Bundle.module
    }
}
