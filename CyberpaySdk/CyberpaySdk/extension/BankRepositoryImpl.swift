//
//  BankRepository.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BankRepositoryImpl: BankRepository {
    
 
    
    let service = BankService()
    
    func getBanks() -> Observable<[BankResponse]> {
        let request = ApiRequest()
        if (Bank.list == nil) {
            return service.banks(request: request)
                .flatMap{
                    result -> Observable<[BankResponse]> in
                    return result.succeeded ? Observable.just(result.data!) : Observable.error(Exception.CyberpayException(message: result.message!))
            }
        }
        else  {
            return Observable.just(Bank.list!)
        }
        
    }
    
    func getAllBanks() -> Observable<ApiResponse<[BankResponse]>> {
        let request = ApiRequest()
        return service.getAllBanks(request: request)
            .flatMap{
                result -> Observable<ApiResponse<[BankResponse]>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
    }
    
    func getAccountName(bankCode: String,  accountNo: String) -> Observable<ApiResponse<AccountResponse>> {
        let request = ApiRequest()
        request.parameters["accountId"] = accountNo
        request.parameters["bankCode"] = bankCode
        
        let keyInBase64 =  CyberpaySdk.INSTANCE.key.data(using: .utf8)?.base64EncodedString()
        
        return service.getAccountName(apiKey: keyInBase64!, request: request)
            .flatMap{
                result -> Observable<ApiResponse<AccountResponse>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
    }
    
    
    
}



