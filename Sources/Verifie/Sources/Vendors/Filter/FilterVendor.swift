//
//  FilterVendor.swift
//  Verifie
//
//  Created by Misha Torosyan on 4/25/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import UIKit

final class FilterVendor: CIFilterConstructor {
    
    static func registerFilters() {
        
        CIFilter.registerName("LuminanceThresholdFilter",
                              constructor: FilterVendor(),
                              classAttributes: [kCIAttributeFilterCategories: "CustomFilters"])
    }
    
    func filter(withName name: String) -> CIFilter? {
        
        if name == "LuminanceThresholdFilter" {
            return LuminanceThresholdFilter()
        }
        
        return nil
    }
}
