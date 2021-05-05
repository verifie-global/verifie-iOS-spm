//
//  DocumentTypeViewController.swift
//  VerifieFramework
//
//  Created by Misha Torosyan on 11/25/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import UIKit
import Verifie

class DocumentTypeViewController: UITableViewController {

    var verifie: Verifie!
    
    var documents: [VerifieDocument] = []
    var score: VerifieScore!
    var liveness: VerifieLiveness!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    //    MARK: - Private Functions
    private func startVerifie(_ documentType: VerifieDocumentType, livenessCheck: Bool = false) {
        
//        let documentScannerViewController: CustomDocScannerViewController = CustomDocScannerViewController.load()
//        let humanDetectorViewController: CustomHumanDetectorViewController = CustomHumanDetectorViewController.load()
//        let secondDocInfoViewController: SecondDocInfoViewController = SecondDocInfoViewController.load()
//        let viewControllersConfigs = VerifieViewControllersConfigs(documentScannerViewController: nil,
//                                                                   humanDetectorViewController: nil,
//                                                                   recommendationsViewController: nil,
//                                                                   docInstructionsViewController: nil,
//                                                                   secondDocInfoViewController: secondDocInfoViewController)
        
        documents = []
        score = nil
        liveness = nil
        
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        let personId = "\(systemName)|\(systemVersion)|\(deviceId)"
        let documentScannerConfigs = VerifieDocumentScannerConfigs(scannerOrientation: .portrait,
                                                                   documentType: documentType)
        let configs = VerifieConfigs(licenseKey: "5d3f2e38-fe7c-43c6-b532-db9b57e674f8",
                                     personId: personId,
                                     livenessCheck: livenessCheck,
                                     textConfigs: VerifieTextConfigs.default(),
                                     viewControllersConfigs: /*viewControllersConfigs*/ nil,
                                     documentScannerConfigs: documentScannerConfigs)
        
        verifie = Verifie(configs: configs, delegate: self)
        
        verifie.start()
    }
    
    private func showAlert(with message: String, title: String? = nil) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .cancel,
                                                handler: nil))
        
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    private func showResultViewController() {
        
        let viewController: VerificationResultViewController = VerificationResultViewController.load()
        
        viewController.firstDocument = documents.first
        viewController.secondDocument = documents.last
        viewController.score = score
        
        show(viewController, sender: self)
    }
    
    
    //    MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                startVerifie(.passport)
                break
            default:
                startVerifie(.idCard)
                break
            }
        case 1:
            startVerifie(.idCard, livenessCheck: true)
            break
        default:
            break
        }
    }
    
    
    // MARK: - Action Functions
    @IBAction private func checkLivenessButtonAction(_ sender: UIButton) {
        
        startVerifie(.unknown, livenessCheck: true)
    }
}

extension DocumentTypeViewController: VerifieDelegate {
    
    func verifie(_ sender: Verifie, didReceive document: VerifieDocument) {
        debugPrint(document)
        documents.append(document)
    }
    
    func verifie(_ sender: Verifie, didCalculate score: VerifieScore) {
    
        self.score = score
        sender.stop()
    }
    
    func verifie(_ sender: Verifie, didCheck liveness: VerifieLiveness) {
        
        self.liveness = liveness
        sender.stop()
    }
    
    func verifie(_ sender: Verifie, didFailWith error: Error) {
        
        let error = error as! VerifieError
        showAlert(with: error.localizedDescription)
    }
    
    func viewControllerToPresent(_ sender: Verifie) -> UIViewController {
        
        return self
    }
    
    func verifieDidFinish(_ sender: Verifie) {
        
        debugPrint("Verifie did finish the job!")
        
        self.verifie = nil
        
        if let liveness = liveness {
            let message = liveness.liveness ? "Liveness Confirmed" : "Spoofing attempt was detected."
            showAlert(with: message, title: "Liveness")
            return
        }
        
        guard (score != nil) else {
            return
        }
        showResultViewController()
    }
}

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
