//
//  VerifieDocumentType.swift
//  Verifie
//
//  Created by Misha Torosyan on 9/25/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objc public enum VerifieDocumentType: Int {
    
    case unknown
    case passport
    case idCard
    case permitCard
    
    init(stringValue: String) {
        switch stringValue.uppercased() {
        case "P":
            self = .passport
        case "ID", "I":
            self = .idCard
        default:
            self = .unknown
        }
    }
}
