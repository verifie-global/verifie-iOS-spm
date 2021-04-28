//
//  AlamofireErrorHandler.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/8/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire

extension DataRequest {
//
//    func responseObject<T: DataResponseSerializer>(
//        queue: DispatchQueue? = nil,
//        completionHandler: @escaping (DataResponse<T>) -> Void)
//        -> Self
//    {
//        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
//            guard error == nil else { return .failure(BackendError.network(error: error!)) }
//
//            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
//            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
//
//            guard case let .success(jsonObject) = result else {
//                return .failure(BackendError.jsonSerialization(error: result.error!))
//            }
//
//            guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
//                return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
//            }
//
//            return .success(responseObject)
//        }
//
//        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
//    }
//
//
//    @discardableResult
//    public func responseDecodable<T: Decodable>(queue: DispatchQueue = .main,
//                                                decoder: DataDecoder = JSONDecoder(),
//                                                completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//
//        return response(queue: queue,
//                        responseSerializer: DecodableResponseSerializer(decoder: decoder),
//                        completionHandler: completionHandler)
//    }
}
