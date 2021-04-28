//
//  LocalizableString.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/16/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

extension String {
    
    func localized() -> String {
        
        let key = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let defaultValue = self
        let bundle = Bundle.sources()
        let localizedString = NSLocalizedString(key,
                                                tableName: nil,
                                                bundle: bundle,
                                                value: defaultValue,
                                                comment: "")
        
        return localizedString
    }
}
