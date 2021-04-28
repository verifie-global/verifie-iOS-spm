//
//  VerifieAPIResponseError.swift
//  Verifie
//
//  Created by Misha Torosyan on 6/5/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

public struct VerifieAPIResponseError: Error {
    
    let code: Int
    let desc: String?
}
