//
//  VerifieDelegate.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/9/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

@objc public protocol VerifieDelegate: class {
    
    func verifie(_ sender: Verifie, didFailWith error: Error)
    
    func viewControllerToPresent(_ sender: Verifie) -> UIViewController
    
    func verifie(_ sender: Verifie, didReceive document: VerifieDocument)
    
    func verifie(_ sender: Verifie, didCalculate score: VerifieScore)
    
    func verifie(_ sender: Verifie, didCheck liveness: VerifieLiveness)
    
    func verifieDidFinish(_ sender: Verifie)
}
