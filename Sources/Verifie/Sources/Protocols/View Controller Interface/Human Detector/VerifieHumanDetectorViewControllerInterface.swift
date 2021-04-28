//
//  VerifieHumanDetectorViewControllerInterface.swift
//  Verifie
//
//  Created by Misha Torosyan on 9/18/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objc public protocol HumanDetectorViewControllerActionsDelegate: class {
    
    func didPressCloseButtonHumanDetectorViewController(_
        sender: VerifieHumanDetectorViewControllerInterface)
}


@objc public protocol VerifieHumanDetectorViewControllerInterface: VerifieViewControllerInterface {
    
    var previewView: VerifieVideoSessionPreviewView! { get set }
    weak var actionsDelegate: HumanDetectorViewControllerActionsDelegate? { get set }
    
    func update(statusText text: String)
    
    func update(_ progress: Double)
}

