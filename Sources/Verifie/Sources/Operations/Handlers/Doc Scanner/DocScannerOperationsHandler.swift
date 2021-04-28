//
//  DocumentScannerOperationsHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/11/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit

protocol DocScannerOperationsHandlerDelegate: OperationsHandlerDelegate {
    
    func docScannerOperationsHandler(_ sender: DocScannerOperationsHandler,
                                     didFailWith error: VerifieError)
    
    func docScannerOperationsHandler(_ sender: DocScannerOperationsHandler,
                                     sending documentImage: UIImage,
                                     pageNumber: DocPageNumber)
    
    func docScannerOperationsHandler(_ sender: DocScannerOperationsHandler,
                                     didReceive document: VerifieDocument)
    
    func docScannerOperationsHandlerDidReceiveStopAction(_ sender: DocScannerOperationsHandler)
}

@objc public enum DocPageNumber: Int {
    
    case first
    case second
}

final class DocScannerOperationsHandler: OperationsHandler {
    
    //    MARK: - Members
    private var docScannerSession: DocScannerSession
    private var docScannerSceneHandler: DocScannerSceneHandler!
    private var docPageNumber: DocPageNumber = .first
    private var textConfigs: VerifieTextConfigs!
    private var colorConfigs: VerifieColorConfigs!
    private var documentScannerConfigs: VerifieDocumentScannerConfigs!
    private var firstPageScanStartDate: Date?
    weak var delegate: DocScannerOperationsHandlerDelegate?
    
    
    //    MARK: - Initializers
    required init(appSession: AppSession) {
        
        docScannerSession = DocScannerSession()
        
        super.init(appSession: appSession)
        
        docScannerSession.delegate = self
    }
    
    func start(with pageNumber: DocPageNumber,
               textConfigs: VerifieTextConfigs,
               colorConfigs: VerifieColorConfigs,
               viewControllersConfigs: VerifieViewControllersConfigs?,
               documentScannerConfigs: VerifieDocumentScannerConfigs) {
        
        self.docPageNumber = pageNumber
        self.textConfigs = textConfigs
        self.colorConfigs = colorConfigs
        self.documentScannerConfigs = documentScannerConfigs
        
        setup(with: viewControllersConfigs)
        
        switch documentScannerConfigs.scannerOrientation {
        case .landscape:
            docScannerSession.imageOrientation = .up
        case .portrait:
            docScannerSession.imageOrientation = .right
        }
        
        guard let docScannerViewController = docScannerSceneHandler.viewController
            as? VerifieBaseViewController else {
                
                handle(VerifieError.unhandledError(nil))
                return
        }
        
        docScannerViewController.lifeCycleDelegate = self
        appSession.uiManager.show(docScannerViewController)
        
        switch pageNumber {
        case .first:
            break
            
        default:
            startDocScannerSession()
            updateDocScannerStatus(with: pageNumber)
        }
    }
    
    func stop() {
        
        docScannerSession.stop()
    }
    
    
    //    MARK: - Private Functions
    private func startDocScannerSession() {
        
        let scanType: DocumentManagerScanType
        if documentScannerConfigs.documentType == .passport {
            scanType = .passport
        } else {
            if docPageNumber == .first {
                scanType = .idCard
                firstPageScanStartDate = Date();
            }
            else {
                scanType = .idCardMRZ
            }
        }
        
        docScannerSession.sessionScannerType = scanType
        
        do {
            try docScannerSession.start()
        }
        catch let error as VerifieError {
            handle(error)
        }
        catch {
            handle(.unhandledError(error))
        }
    }
    
    private func setup(with viewControllersConfigs: VerifieViewControllersConfigs?) {
        
        if docScannerSceneHandler == nil {
            
            if let viewController = viewControllersConfigs?.documentScannerViewController {
                docScannerSceneHandler = SceneHandlerFactory.scene(viewController)
            }
            else {
                
                let viewController: DocScannerViewController = DocScannerViewController.load()
                docScannerSceneHandler = SceneHandlerFactory.scene(viewController)
            }
            
            docScannerSceneHandler.delegate = self
        }
    }
    
    private func startDocScannerSession(with
        viewController: VerifieDocScannerViewControllerInterface) {
        
        updateDocScannerStatus(with: docPageNumber)
        
        docScannerSession.set(croppingAreaView: viewController.croppingAreaView)
        docScannerSession.set(previewView: viewController.videoPreviewView)
        
        startDocScannerSession()
    }
    
    private func updateDocScannerStatus(with pageNumber: DocPageNumber) {
        
        let viewController = docScannerSceneHandler.viewController
        
        viewController.updateText(with: textConfigs.documentScannerConfigs,
                                  documentType: documentScannerConfigs.documentType,
                                  pageNumber: pageNumber)
        
        viewController.croppingAreaImageView.tintColor = colorConfigs.docCropperFrameColor
        viewController.instructionsTitleLabel.textColor = colorConfigs.docCropperFrameColor
        viewController.instructionsSubtitleLabel.textColor = colorConfigs.docCropperFrameColor
    }
    
    private func handle(_ docImage: UIImage) {
        
        docScannerSession.stop()
        generateHapitc(.success)
        delegate?.docScannerOperationsHandler(self, sending: docImage, pageNumber: docPageNumber)
        
        DispatchQueue(label: "ImageToBase64").async { [weak self] in
            
            guard
                let weakSelf = self,
                let imageData = docImage.jpeg(.highest)
                else {
                    return
            }
            
            let base64Image = imageData.base64EncodedString()
            
            let mainService: MainService = weakSelf.appSession
                .servicesProvider
                .getService(apiManager: weakSelf.appSession.apiManager)
            
            mainService
                .sendDocumentImage(base64Image,
                                   completion: { (result: Result<VerifieDocument, VerifieError>) in
                                    
                                    switch result {
                                    case .success(let document):
                                        weakSelf.handle(document, documentImageData: base64Image)
                                    case .failure(let error):
                                        weakSelf.handle(error)
                                    }
                })
        }
    }
    
    private func handle(_ document: VerifieDocument, documentImageData: String) {
        
        document.update(documentImage: documentImageData)
        delegate?.docScannerOperationsHandler(self, didReceive: document)
    }
    
    private func handle(_ error: VerifieError) {
        
        generateHapitc(.error)
        delegate?.docScannerOperationsHandler(self, didFailWith: error)
    }
    
    private func generateHapitc(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        
        DispatchQueue.main.async {        
            UINotificationFeedbackGenerator().notificationOccurred(notificationType)
        }
    }
}


extension DocScannerOperationsHandler: DocScannerSessionDelegate {
    
    func docScannerSession(_ sender: DocScannerSession, didScan docImage: UIImage) {
        
        if docPageNumber == .first,
            documentScannerConfigs.documentType == .idCard,
            let firstPageScanStartDate = firstPageScanStartDate {
            
            let passedTime = fabs(firstPageScanStartDate.timeIntervalSinceNow)
            if passedTime >= 2 {
                handle(docImage)
            }
        }
        else {
            handle(docImage)
        }
    }
    
    func docScannerSession(_ sender: DocScannerSession, didFailWith error: VerifieError) {
        DispatchQueue.main.async {
            self.handle(error)
        }
    }
}

extension DocScannerOperationsHandler: VerifieBaseViewControllerDelegate {
    
    func viewControllerViewDidLoad(_ sender: VerifieBaseViewController) {
        
        guard let viewController = sender as? VerifieDocScannerViewControllerInterface else {
            
            handle(VerifieError.unhandledError(nil))
            return
        }
        
        startDocScannerSession(with: viewController)
    }
}

extension DocScannerOperationsHandler: DocScannerSceneHandlerDelegate {
    
    func docScannerSceneHandlerDidReceiveCloseAction(_ sender: DocScannerSceneHandler) {
        
        delegate?.docScannerOperationsHandlerDidReceiveStopAction(self)
    }
}
