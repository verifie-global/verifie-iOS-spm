//
//  VerifieProtocol.swift
//  Verifie
//
//  Created by Misha Torosyan on 6/4/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

public protocol VerifieProtocol {
    
    init(configs: VerifieConfigs, delegate: VerifieDelegate)
    
    func start()
    
    func stop()
}
