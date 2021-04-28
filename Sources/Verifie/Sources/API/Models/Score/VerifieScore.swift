//
//  VerifieScore.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Foundation

public class VerifieScore: NSObject, Codable {
    
    public let facialScore: Double
    public let facialLiveness: Bool
    public let predictedGender: String?
    public let predictedAge: Int
    public let isMatched: Bool
    public let livenessScore: Double
    
    public private(set) var faceImage: String?
    
    func update(faceImage: String) {
        self.faceImage = faceImage
    }
    
    public init(facialScore: Double,
                facialLiveness: Bool,
                predictedGender: String?,
                predictedAge: Int,
                faceImage: String?,
                isMatched: Bool,
                livenessScore: Double) {
        
        self.facialScore = facialScore
        self.facialLiveness = facialLiveness
        self.predictedGender = predictedGender
        self.predictedAge = predictedAge
        self.faceImage = faceImage
        self.isMatched = isMatched
        self.livenessScore = livenessScore
    }
    
    override public var description: String {
        return
            "score: \(facialScore)\n" +
            "liveness: \(facialLiveness)\n" +
            "predictedGender: \(predictedGender ?? "-")\n" +
            "predictedAge: \(predictedAge)\n" +
            "isMatched: \(isMatched)\n" +
            "livenessScore: \(livenessScore)\n"
    }
}
