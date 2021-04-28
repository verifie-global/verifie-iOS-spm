//
//  VerifieSecondDocInfoViewControllerInterface.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/6/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import Foundation

@objc public protocol SecondDocInfoViewControllerActionsDelegate: class {

    func didPressCloseSecondDocInfoViewController(_
    sender: VerifieSecondDocInfoViewControllerInterface)
    
    func didPressContinueSecondDocInfoViewController(_
        sender: VerifieSecondDocInfoViewControllerInterface)
}


@objc public protocol VerifieSecondDocInfoViewControllerInterface: VerifieViewControllerInterface {
    
    weak var actionsDelegate: SecondDocInfoViewControllerActionsDelegate? { get set }
    
    func update(documentType: VerifieDocumentType)
}
