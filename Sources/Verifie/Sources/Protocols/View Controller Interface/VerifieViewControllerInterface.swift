//
//  VerifieViewControllerInterface.swift
//  Verifie
//
//  Created by Misha Torosyan on 7/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objc public protocol VerifieViewControllerInterface {
    
    weak var lifeCycleDelegate: VerifieBaseViewControllerDelegate? { get set }
}
