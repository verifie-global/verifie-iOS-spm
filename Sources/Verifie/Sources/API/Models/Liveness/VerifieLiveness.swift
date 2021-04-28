//
//  VerifieLiveness.swift
//  Verifie
//
//  Created by Misha Torosyan on 7/1/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import Foundation

public class VerifieLiveness: NSObject, Codable {
    
    public let liveness: Bool
    public private(set) var faceImage: String?
    
    func update(faceImage: String) {
        self.faceImage = faceImage
    }

    public init(liveness: Bool) {
        self.liveness = liveness
    }
    
    override public var description: String {
        return
            "liveness: \(liveness)\n"
    }
}
