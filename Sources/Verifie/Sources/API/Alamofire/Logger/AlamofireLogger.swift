//
//  AlamofireLogger.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/15/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import Foundation
import Alamofire

final class AlamofireLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
//        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
//        let message = """
//        ⚡️ Request Started: \(request)
//        ⚡️ Body Data: \(body)
//        """
//        debugPrint(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
//        debugPrint("⚡️ Response Received: \(response.debugDescription)")
    }
}
