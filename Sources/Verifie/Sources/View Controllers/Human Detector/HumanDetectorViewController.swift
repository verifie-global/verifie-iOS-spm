//
//  HumanDetectorViewController.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

class HumanDetectorViewController: VerifieBaseViewController, VerifieHumanDetectorViewControllerInterface {
    
    @IBOutlet weak var previewView: VerifieVideoSessionPreviewView! {
        didSet {
            previewView.autorotate = false
        }
    }
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var progressOverlayView: VerifieHumanDetectorProgressView!
    
    weak var actionsDelegate: HumanDetectorViewControllerActionsDelegate?
    
    private var isUpdatingStatusText = false
    private var lastStatusText = ""
    
    
    //    MARK: Lifecycle Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        attemptRotationToPortrait()
    }
    
    
    //    MARK: - Internal Functions
    func update(statusText text: String) {
        
        if isUpdatingStatusText {
            lastStatusText = text
            return
        }
        
        isUpdatingStatusText = true
        
        UIView.transition(with: self.statusLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.statusLabel.text = text },
                          completion: { (finished) in
                            self.isUpdatingStatusText = false
                            if self.statusLabel.text != self.lastStatusText {
                                self.update(statusText: self.lastStatusText)
                            }
        })
    }
    
    func update(_ progress: Double) {
        
        progressOverlayView.set(Float(progress))
    }
    
    
    //    MARK: - Private Functions
    private func attemptRotationToPortrait() {
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    
    //    MARK: Action Functions
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        
        actionsDelegate?.didPressCloseButtonHumanDetectorViewController(self)
    }
}
