//
//  VerifieError.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/9/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

public enum VerifieError: Error {
    
    case unhandledError(Error?)
    case missingPreviewView
    case missingCroppingAreaView
    case missingViewController
    case apiError([Error]?)
    case apiResponseError([VerifieAPIResponseError]?)
    case apiValidationError([VerifieValidation]?)
    case wrongDocumentType
}

public extension VerifieError {
    
    var localizedDescription: String {
        
        switch self {
        case .unhandledError:
            return "Please contact with developers"
        case .missingPreviewView:
            return "previewView can't be nil"
        case .missingCroppingAreaView:
            return "croppingAreaView can't be nil"
        case .missingViewController:
            return "view controller can't be nil"
        case .apiError(let errors):
            return errors?.first?.localizedDescription ?? "Unknown error"
        case .apiValidationError(let errors):
            if let error = errors?.first { return "\(error.errorKey): \(error.errorDesc)" }
            else { return "Unknown error" }
        case .apiResponseError(let errors):
            if let error = errors?.first {
                return "\(error.desc ?? "Unknown error")"
            }
            else { return "Unknown error" }
        case .wrongDocumentType:
            return "Wrong scanned document"
        }
    }
    
    var userInfo: [String: Any] {
        return [NSLocalizedDescriptionKey: localizedDescription]
    }
}

@objc public extension NSError {
    
    /// Returns user info for Verifie error. Use only for Objective-C calls
    var verifieUserInfo: [String: Any]? {
        
        guard let error = self as? VerifieError else {
            return nil
        }
        
        return error.userInfo
    }
}
