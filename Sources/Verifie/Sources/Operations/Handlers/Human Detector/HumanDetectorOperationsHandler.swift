//
//  HumanDetectorOperationsHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

protocol HumanDetectorOperationsHandlerDelegate: OperationsHandlerDelegate {
    
    func humanDetectorOperationsHandler(_ sender: HumanDetectorOperationsHandler,
                                        didCalculate score: VerifieScore)
    
    func humanDetectorOperationsHandler(_ sender: HumanDetectorOperationsHandler,
                                        didCheck liveness: VerifieLiveness)
    
    func humanDetectorOperationsHandler(_ sender: HumanDetectorOperationsHandler,
                                        didFailWith error: VerifieError)
    
    func HumanDetectorOperationsHandlerDidReceiveStopAction(_
        sender: HumanDetectorOperationsHandler)
}

final class HumanDetectorOperationsHandler: OperationsHandler {
    
    //    MARK: - Members
    private var humanDetectorSession: HumanDetectorSession
    private var humanDetectorSceneHandler: HumanDetectorSceneHandler!
    private var textConfigs: VerifieTextConfigs!
    private var livenessCheck = false
    private var lockSending = false
    private let lock = NSLock()
    
    weak var delegate: HumanDetectorOperationsHandlerDelegate?
    
    
    //    MARK: - Initializers
    required init(appSession: AppSession) {
        
        humanDetectorSession = HumanDetectorSession()
        
        super.init(appSession: appSession)
        
        humanDetectorSession.delegate = self
    }
    
    
    //    MARK: - Internal Functions
    func start(_ textConfigs: VerifieTextConfigs,
               livenessCheck: Bool,
               viewControllersConfigs: VerifieViewControllersConfigs?) {
        
        self.textConfigs = textConfigs
        self.livenessCheck = livenessCheck
        
        setup(with: viewControllersConfigs)
        
        guard let humanDetectorViewController = humanDetectorSceneHandler.viewController
            as? VerifieBaseViewController else {
                
                handle(VerifieError.unhandledError(nil))
                return
        }
        
        humanDetectorViewController.lifeCycleDelegate = self
        appSession.uiManager.show(humanDetectorViewController)
    }
    
    func stop() {
        
        humanDetectorSession.stop()
    }
    
    
    //    MARK: - Private Functions
    private func setup(with viewControllersConfigs: VerifieViewControllersConfigs?) {
        
        if let viewController = viewControllersConfigs?.humanDetectorViewController {
            humanDetectorSceneHandler = SceneHandlerFactory.scene(viewController)
        }
        else {
            
            let viewController: HumanDetectorViewController = HumanDetectorViewController.load()
            humanDetectorSceneHandler = SceneHandlerFactory.scene(viewController)
        }
        
        humanDetectorSceneHandler.delegate = self
    }
    
    private func startHumanDetectorSession(with
        viewController: VerifieHumanDetectorViewControllerInterface) {
        
        humanDetectorSession.set(previewView: viewController.previewView)
        viewController.update(statusText: textConfigs.movePhoneCloser)
        
        do {
            try humanDetectorSession.start()
        }
        catch let error as VerifieError {
            handle(error)
        }
        catch {
            handle(.unhandledError(error))
        }
    }
    
    private func send(_ image: UIImage) {
        
        lock.lock();
        
        let flippedImage = image.withHorizontallyFlippedOrientation()
        
        DispatchQueue(label: "ImageToBase64").async { [weak self] in
            
            guard
                let base64Image = flippedImage.jpeg(.medium)?.base64EncodedString(),
                let weakSelf = self
                else {
                    return
            }
            
            let mainService: MainService = weakSelf.appSession
                .servicesProvider
                .getService(apiManager: weakSelf.appSession.apiManager)
            
            mainService
                .sendSelfieImage(base64Image,
                                 completion: { (result: Result<VerifieScore, VerifieError>) in
                                    
                                    guard let weakSelf = self else {
                                        
                                        self?.handle(.unhandledError(nil))
                                        return
                                    }
                                    
                                    weakSelf.lock.unlock();
                                    
                                    switch result {
                                    case .success(let score):
                                        weakSelf.handle(score, faceImageData: base64Image)
                                    case .failure(let error):
                                        weakSelf.handle(error)
                                    }
                })
        }
    }
    
    private func checkLiveness(_ image: UIImage) {
        
        lock.lock();
        
        let flippedImage = image.withHorizontallyFlippedOrientation()
        
        DispatchQueue(label: "ImageToBase64").async { [weak self] in
            
            guard
                let base64Image = flippedImage.jpeg(.medium)?.base64EncodedString(),
                let weakSelf = self
                else {
                    return
            }
            
            let mainService: MainService = weakSelf.appSession
                .servicesProvider
                .getService(apiManager: weakSelf.appSession.apiManager)
            
            mainService
                .checkLiveness(base64Image,
                                 completion: { (result: Result<VerifieLiveness, VerifieError>) in
                                    
                                    guard let weakSelf = self else {
                                        
                                        self?.handle(.unhandledError(nil))
                                        return
                                    }
                                    
                                    weakSelf.lock.unlock();
                                    
                                    switch result {
                                    case .success(let liveness):
                                        weakSelf.handle(liveness, faceImageData: base64Image)
                                    case .failure(let error):
                                        weakSelf.handle(error)
                                    }
                })
        }
    }
    
    private func handle(_ error: VerifieError) {
        
        delegate?.humanDetectorOperationsHandler(self, didFailWith: error)
    }
    
    private func showHumanDetectionFailedAlert(with message: String) {
        
        appSession.uiManager.showAlert(title: "", message: message) {
            self.humanDetectorSession.resetFailuresCount()
        }
    }
    
    
    //    MARK: - Human Detector
    private func handle(_ result: LivenessManagerResult, sourceImage: UIImage?) {
        
        DispatchQueue.main.async {
            
            switch result {
            case .moveCloser:
                self.handleMoveCloser()
            case .moveAway:
                self.handleMoveAway()
            case .holdStill:
                self.handleHoldStill()
            case .live:
                guard let sourceImage = sourceImage else { return }
                self.handleHumanDetected(sourceImage)
            case .faceFailed:
                self.showHumanDetectionFailedAlert(with: self.textConfigs.faceFailed)
            case .eyesFailed:
                self.showHumanDetectionFailedAlert(with: self.textConfigs.eyesFailed)
            case .timeout:
                self.handleDetectionTimeout()
            }
        }
    }
    
    private func handleMoveCloser() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else { return }
            
            weakSelf
                .humanDetectorSceneHandler
                .viewController.update(statusText: weakSelf.textConfigs.movePhoneCloser)
        }
    }
    
    private func handleMoveAway() {
       
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else { return }
            
            weakSelf
                .humanDetectorSceneHandler
                .viewController
                .update(statusText: weakSelf.textConfigs.movePhoneAway)
        }
    }
    
    private func handleHoldStill() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else { return }
            
            weakSelf
                .humanDetectorSceneHandler
                .viewController
                .update(statusText: weakSelf.textConfigs.holdStill)
        }
    }
    
    private func handleHumanDetected(_ humanPhoto: UIImage) {
        
        humanDetectorSession.stop()
        
        if (!lockSending) {
            
            lockSending = true
            
            if (livenessCheck) {
                checkLiveness(humanPhoto)
            }
            else {            
                send(humanPhoto)
            }
        }
    }
    
    private func handleDetectionTimeout() {
        
        self.humanDetectorSession.stop()
        
        appSession.uiManager.showAlert(title: "", message: self.textConfigs.detectionFailed) {
            self.delegate?.HumanDetectorOperationsHandlerDidReceiveStopAction(self)
        }
    }
    
    private func handle(_ score: VerifieScore, faceImageData: String) {
        
        score.update(faceImage: faceImageData)
        
        delegate?.humanDetectorOperationsHandler(self, didCalculate: score)
    }
    
    private func handle(_ liveness: VerifieLiveness, faceImageData: String) {
        
        liveness.update(faceImage: faceImageData)
        
        delegate?.humanDetectorOperationsHandler(self, didCheck: liveness)
    }
    
    private func handle(_ livenessPercent: Double) {
        
        DispatchQueue.main.async {
            self.humanDetectorSceneHandler.viewController.update(livenessPercent)
        }
    }
}


extension HumanDetectorOperationsHandler: HumanDetectorSessionDelegate {
    
    func humanDetectorSession(_ session: HumanDetectorSession,
                              didReceive result: LivenessManagerResult,
                              with sourceImage: UIImage?) {
        
        handle(result, sourceImage: sourceImage)
    }
    
    func humanDetectorSession(_ session: HumanDetectorSession,
                              didReceive livenessPercent: Double) {
        
        handle(livenessPercent)
    }
}


extension HumanDetectorOperationsHandler: VerifieBaseViewControllerDelegate {
    
    func viewControllerViewDidLoad(_ sender: VerifieBaseViewController) {
        
        guard let viewController = sender as? VerifieHumanDetectorViewControllerInterface else {
            
            handle(VerifieError.unhandledError(nil))
            return
        }
        
        startHumanDetectorSession(with: viewController)
    }
}

extension HumanDetectorOperationsHandler: HumanDetectorSceneHandlerDelegate {
    
    func humanDetectorSceneHandlerDidReceiveCloseAction(_ sender: HumanDetectorSceneHandler) {
        
        delegate?.HumanDetectorOperationsHandlerDidReceiveStopAction(self)
    }
}

