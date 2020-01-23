//
//  TransactionService.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/2/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TransactionService {
    
    private let apiClient = ApiClient()
    
    /*
     set transaction to get transaction reference
     */
    func begingTransaction(request : ApiRequest) -> Observable<ApiResponse<SetTransaction>> {
        request.path = "payments"
        return apiClient.send(apiRequest: request)
    }
    
    /*
     begin card transation
     */
    func chargeCard(request : ApiRequest) -> Observable<ApiResponse<ChargeCard>> {
        request.path = "payments/card"
        return apiClient.send(apiRequest: request)
    }
    
    /*
     verify transation status given the transaction reference
     */
    func verifyTransactionByReference(ref : String) -> Observable<ApiResponse<VerifyTransaction>> {
        let request = ApiRequest()
        request.path = "payments/" + ref
        request.method = RequestType.GET
        return apiClient.send(apiRequest: request)
    }
    
    /*
     verify transation status given the merchant transaction reference
     
    func verifyTransactionByMerchantReference(ref : String) -> Observable<ApiResponse<VerifyMerchantTransaction>> {
        let request = ApiRequest()
        request.path = "payments/" + ref
        request.method = RequestType.GET
        return apiClient.send(apiRequest: request)
    }
     */
    
    
    /*
        verify card otp to complete transaction
    */
    func verifyCardOtp(request : ApiRequest) -> Observable<ApiResponse<VerifyOtp>> {
       request.path = "payments/otp"
       return apiClient.send(apiRequest: request)
    }
    
    /*
        verify bank otp to complete transaction
    */
    func verifyBankOtp(request : ApiRequest) -> Observable<ApiResponse<VerifyOtp>> {
       request.path = "payments/bank/otp"
       return apiClient.send(apiRequest: request)
    }
    
    /*
        begin a bank transation
    */
    func chargeBank(request : ApiRequest) -> Observable<ApiResponse<ChargeBank>> {
       request.path = "payments/bank"
       return apiClient.send(apiRequest: request)
    }
    
    /*
        register customer phone for otp
    */
    func enrollBankOtp(request : ApiRequest) -> Observable<ApiResponse<EnrollOtp>> {
       request.path = "payments/bank/enrol/otp"
       return apiClient.send(apiRequest: request)
    }
    
    
    /*
        register customer phone for otp
    */
    func enrollCardOtp(request : ApiRequest) -> Observable<ApiResponse<EnrollOtp>> {
       request.path = "payments/card/enrol"
       return apiClient.send(apiRequest: request)
    }
    
    
}
