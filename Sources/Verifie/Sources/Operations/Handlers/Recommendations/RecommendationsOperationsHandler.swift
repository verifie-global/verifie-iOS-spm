//
//  RecommendationsOperationsHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 11/23/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation
import AVFoundation

protocol RecommendationsOperationsHandlerDelegate: OperationsHandlerDelegate {
 
    func recommendationsOperationsHandlerDidReceiveStopAction(_ sender: RecommendationsOperationsHandler)
    
    func recommendationsOperationsHandlerDidReceiveContinueAction(_ sender: RecommendationsOperationsHandler)
    
    func recommendationsOperationsHandler(_ sender: RecommendationsOperationsHandler,
                                          didFailWith error: VerifieError)
}

final class RecommendationsOperationsHandler: OperationsHandler {
    
    //    MARK: - Private Members
    private var videoSession: VideoSession
    private var recommendationsSceneHandler: RecommendationsSceneHandler!
    private var textConfigs: VerifieTextConfigs!
    
    //    MARK: - Internal Members
    weak var delegate: RecommendationsOperationsHandlerDelegate?
    

    //    MARK: - Initializers
    required init(appSession: AppSession) {
        
        videoSession = VideoSession()
        videoSession.session.sessionPreset = .photo
        videoSession.session.addOutput(AVCapturePhotoOutput())
        let deviceInput = try? VideoSession.captureDeviceInput(type: .frontCamera)
        videoSession.captureDeviceInput = deviceInput
        
        super.init(appSession: appSession)
    }
    
    
    //    MARK: - Internal Functions
    func start(_ textConfigs: VerifieTextConfigs,
               viewControllersConfigs: VerifieViewControllersConfigs?) {
        
        self.textConfigs = textConfigs
        
        setup(with: viewControllersConfigs)
        
        guard let recommendationsViewController = recommendationsSceneHandler.viewController
            as? VerifieBaseViewController else {
                
                handle(VerifieError.unhandledError(nil))
                return
        }
        
        recommendationsViewController.lifeCycleDelegate = self
        appSession.uiManager.show(recommendationsViewController)
    }
    
    
    //    MARK: - Private Functions
    private func setup(with viewControllersConfigs: VerifieViewControllersConfigs?) {
        
        if let viewController = viewControllersConfigs?.recommendationsViewController {
            recommendationsSceneHandler = SceneHandlerFactory.scene(viewController)
        }
        else {
            
            let viewController: RecommendationsViewController = RecommendationsViewController.load()
            recommendationsSceneHandler = SceneHandlerFactory.scene(viewController)
        }
        
        recommendationsSceneHandler.delegate = self
    }
    
    private func start(with
        viewControllerInterface: VerifieRecommendationsViewControllerInterface,
                       sceneHandler: RecommendationsSceneHandler,
                       textConfigs: VerifieTextConfigs) {
        
//        videoSession.set(previewView: recommendationsSceneHandler.viewController.videoPreviewView)
//        
//        do {
//            try videoSession.start()
            sceneHandler.viewController.update(textConfigs.recommendationsConfigs)
//        }
//        catch let error as VerifieError {
//            handle(error)
//        }
//        catch {
//            handle(.unhandledError(error))
//        }
    }
    
    private func handle(_ error: VerifieError) {
        
        delegate?.recommendationsOperationsHandler(self, didFailWith: error)
    }
}

extension RecommendationsOperationsHandler: VerifieBaseViewControllerDelegate {
    
    func viewControllerViewDidLoad(_ sender: VerifieBaseViewController) {
        
        guard let interface = sender as? VerifieRecommendationsViewControllerInterface else {
            
            handle(VerifieError.unhandledError(nil))
            return
        }
        
        start(with: interface,
              sceneHandler: recommendationsSceneHandler,
              textConfigs: textConfigs)
    }
}

extension RecommendationsOperationsHandler: RecommendationsSceneHandlerDelegate {
    
    func recommendationsSceneHandlerDidReceiveCloseAction(_ sender: RecommendationsSceneHandler) {
        
        delegate?.recommendationsOperationsHandlerDidReceiveStopAction(self)
    }
    
    func recommendationsSceneHandlerDidReceiveContinueAction(_ sender: RecommendationsSceneHandler) {
        
        delegate?.recommendationsOperationsHandlerDidReceiveContinueAction(self)
    }
}
