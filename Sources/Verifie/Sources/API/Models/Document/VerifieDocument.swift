//
//  VerifieDocument.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/11/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

@objcMembers
public class VerifieDocument: NSObject, Codable {
    
    public let documentType: String?
    public let documentNumber: String?
    public let birthDate: String?
    public let expiryDate: String?
    public let firstname: String?
    public let lastname: String?
    public let gender: String?
    public let nationality: String?
    public let country: String?
    public private(set) var documentImage: String?
    public let documentFaceImage: String?
    public let documentValid: Bool
    public let nextPage: Bool
    
    
    public init(documentType: String?,
                documentNumber: String?,
                birthDate: String?,
                expiryDate: String?,
                firstname: String?,
                lastname: String?,
                gender: String?,
                nationality: String?,
                country: String?,
                documentImage: String?,
                documentFaceImage: String?,
                documentValid: Bool,
                nextPage: Bool) {
        
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.birthDate = birthDate
        self.expiryDate = expiryDate
        self.firstname = firstname
        self.lastname = lastname
        self.gender = gender
        self.nationality = nationality
        self.country = country
        self.documentImage = documentImage
        self.documentFaceImage = documentFaceImage
        self.documentValid = documentValid
        self.nextPage = nextPage
        
        super.init()
    }
    
    public func parsedDocumentType() -> VerifieDocumentType {
        
        switch documentType {
        case "passport":
            return .passport
        case "idCard":
            return .idCard
        case "permitCard":
            return .permitCard
        default:
            return .unknown
        }
    }
    
    public func update(documentImage: String?) {
        self.documentImage = documentImage
    }
    
    override public var description: String {
        return
            "documentType: \(documentType ?? "--")\n" +
            "documentNumber: \(documentNumber ?? "--")\n" +
            "birthDate: \(birthDate ?? "--")\n" +
            "expiryDate: \(expiryDate ?? "--")\n" +
            "firstname: \(firstname ?? "--")\n" +
            "lastname: \(lastname ?? "--")\n" +
            "gender: \(gender ?? "--")\n" +
            "nationality: \(nationality ?? "--")\n" +
            "country: \(country ?? "--")\n" +
            "documentValid: \(documentValid)\n" +
            "nextPage: \(nextPage)\n"
    }
}
