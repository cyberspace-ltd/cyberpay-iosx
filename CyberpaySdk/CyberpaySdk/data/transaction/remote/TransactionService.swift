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

class TransactionService: TransactionServiceProtocol {


    
    private let apiClient = ApiClient()
    
    /*
     set transaction to get transaction reference
     */
    func beginTransaction(request : ApiRequest) -> Observable<ApiResponse<SetTransaction>> {
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
    
    func getTransactionAdvice(transaction : Transaction, channelCode: String) -> Observable<ApiResponse<Advice>> {
           let request = ApiRequest()
        request.path = "payments/\(transaction.reference)/advice/?channelcode=\(channelCode)"
            request.method = RequestType.GET
            return apiClient.send(apiRequest: request)
    }
    
    /*
     verify transation status given the transaction reference
     */
    func verifyTransactionByReference(reference : String) -> Observable<ApiResponse<VerifyTransaction>> {
        let request = ApiRequest()
        request.path = "payments/" + reference
        request.method = RequestType.GET
        return apiClient.send(apiRequest: request)
    }
    
    /*
     verify transation status given the merchant transaction reference
     */
       func verifyTransactionByMerchantReference(merchantReference: String) -> Observable<ApiResponse<VerifyMerchantTransaction>> {
         let request = ApiRequest()
              request.path = "transactions/transactionsBymerchantRef/?merchantRef=\(merchantReference)"
              request.method = RequestType.GET
              return apiClient.send(apiRequest: request)
     }
    
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
    
    

      func enrolBank(request: ApiRequest) -> Observable<ApiResponse<EnrollBank>> {
        request.path = "payments/bank/enroll"
        return apiClient.send(apiRequest: request)
      }
    
    func finalBankOtp(request: ApiRequest) -> Observable<ApiResponse<VerifyOtp>> {
     request.path = "payments/bank/finalotp"
     return apiClient.send(apiRequest: request)
    }
    
    func mandateBankOtp(request: ApiRequest) -> Observable<ApiResponse<EnrollOtp>> {
          request.path = "payments/bank/mandateotp"
          return apiClient.send(apiRequest: request)
    }
    

    
    func updateTransactionClientType(request: ApiRequest) -> Observable<ApiResponse<EnrollOtp>> {
       request.path = "payments/clienttype"
       return apiClient.send(apiRequest: request)

    }
    
    func cancelTransaction(transaction : Transaction, request: ApiRequest) -> Observable<ApiResponse<AnyCodable>> {
        request.path = "payments/\(transaction.reference)/cancel"
        return apiClient.send(apiRequest: request)
    }
}
