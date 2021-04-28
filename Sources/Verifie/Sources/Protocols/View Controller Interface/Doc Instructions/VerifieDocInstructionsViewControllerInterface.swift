//
//  VerifieDocInstructionsViewControllerInterface.swift
//  Verifie
//
//  Created by Misha Torosyan on 12/3/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objc public protocol DocInstructionsViewControllerActionsDelegate: class {

    func didPressCloseDocInstructionsViewController(_
    sender: VerifieDocInstructionsViewControllerInterface)
    
    func didPressContinueDocInstructionsViewController(_
        sender: VerifieDocInstructionsViewControllerInterface)
}


@objc public protocol VerifieDocInstructionsViewControllerInterface: VerifieViewControllerInterface {
    
    weak var actionsDelegate: DocInstructionsViewControllerActionsDelegate? { get set }
    
    func update(with textConfigs: VerifieDocInstructionsTextConfigs,
                documentType: VerifieDocumentType)
}
