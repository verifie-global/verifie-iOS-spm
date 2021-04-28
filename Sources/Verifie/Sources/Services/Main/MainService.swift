//
//  MainService.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/12/19.
//  Copyright © 2019 Misha Torosyan. All rights reserved.
//

import Alamofire

final class MainService: BaseService {
    
    //    MARK: - Internal Functions
    func authorize(_ licenseKey: String,
                   personId: String?,
                   completion: @escaping (Result<VerifieAccessToken, VerifieError>) -> Void) {
        
        let request = AuthorizationRouter.accessToken(licenseKey: licenseKey, personId: personId)
        
        apiManager
            .send(request, showLoading: true)
            .responseDecodable(completionHandler: { [weak self]
                (response: DataResponse<APIResult<VerifieAccessToken>, AFError>) in
                
                self?.handleSuccessResponse(response: response, completion: completion)
            })
    }
    
    func sendDocumentImage(_ imageData: String,
                           completion: @escaping (Result<VerifieDocument, VerifieError>) -> Void) {
        
        let request = DocumentRouter.document(imageData: imageData)

        apiManager
            .send(request, showLoading: false)
            .responseDecodable(completionHandler: { [weak self]
                (response: DataResponse<APIResult<VerifieDocument>, AFError>) in
                
                self?.handleSuccessResponse(response: response, completion: completion)
            })
    }
    
    func sendSelfieImage(_ imageData: String,
                         completion: @escaping (Result<VerifieScore, VerifieError>) -> Void) {
        
        
        let request = ScoreRouter.score(imageData: imageData)

        apiManager
            .send(request, showLoading: true)
            .responseDecodable(completionHandler: { [weak self]
                (response: DataResponse<APIResult<VerifieScore>, AFError>) in
                
                self?.handleSuccessResponse(response: response, completion: completion)
            })
    }
    
    func checkLiveness(_ imageData: String,
                         completion: @escaping (Result<VerifieLiveness, VerifieError>) -> Void) {
        
        
        let request = LivenessRouter.liveness(imageData: imageData)

        apiManager
            .send(request, showLoading: true)
            .responseDecodable(completionHandler: { [weak self]
                (response: DataResponse<APIResult<VerifieLiveness>, AFError>) in
                
                self?.handleSuccessResponse(response: response, completion: completion)
            })
    }
    
    
    //    MARK: - Private Functions
    private func handleSuccessResponse<T>(response: DataResponse<APIResult<T>, AFError>,
                                          completion: @escaping (Result<T, VerifieError>) -> Void) {
        
        switch response.result {
        case .success(let value):
            if value.isSuccess, let result = value.result {
                completion(.success(result))
            }
            else {
                if let validation = value.validation {
                    completion(.failure(VerifieError.apiValidationError(validation)))
                }
                else {
                    completion(.failure(VerifieError.apiResponseError([value.error])))
                }
            }
        case .failure(let error):
            completion(.failure(VerifieError.apiError([error])))
        }
    }
}
