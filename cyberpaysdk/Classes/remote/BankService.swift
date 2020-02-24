//
//  BankService.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BankService: BankServiceProtocol {
    func banks(request: ApiRequest) -> Observable<ApiResponse<[BankResponse]>> {
        request.path = "banks"
        request.method = RequestType.GET
        
        return apiClient.send(apiRequest: request)
    }
    
    func getAllBanks(request: ApiRequest) -> Observable<ApiResponse<[BankResponse]>> {
        request.path = "banks/all"
        request.method = RequestType.GET
        
        return apiClient.send(apiRequest: request)
    }
    
    func getAccountName(apiKey: String, request: ApiRequest) -> Observable<ApiResponse<AccountResponse>> {
        request.path = "payments/bankaccount/name"
        request.headers["ApiKey"] = apiKey
        request.method =  .POST
        return apiClient.send(apiRequest: request)
    }
    
    private let apiClient = ApiClient()
    
    
}
