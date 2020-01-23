//
//  TransactionRepository.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/2/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

internal class TransactionRepository {
    
    let service = TransactionService()
    
    func beginTransaction(transaction : Transaction) -> Observable<ApiResponse<SetTransaction>> {
        let request = ApiRequest()
        
        request.parameters["currency"] = transaction.currency
        request.parameters["merchantRef"] = transaction.merchantReference
        request.parameters["amount"] = transaction.amount
        request.parameters["description"] = transaction.description
        request.parameters["integrationKey"] = transaction.key
        request.parameters["returnUrl"] = transaction.returnUrl
        request.parameters["customerEmail"] = transaction.customerEmail
        request.parameters["clientType"] = transaction.clientType
        request.parameters["splits"] = transaction.splits
         
        return service.begingTransaction(request: request)
            .flatMap{
             result -> Observable<ApiResponse<SetTransaction>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
        
    }
    
    func chargeCard(transaction : Transaction) -> Observable<ApiResponse<ChargeCard>> {
        let request = ApiRequest()
        request.parameters["Expiry"] = transaction.card.expiry
        request.parameters["ExpiryMonth"] = transaction.card.expiryMonth
        request.parameters["ExpiryYear"] = transaction.card.expiryYear
        request.parameters["CardNumber"] = transaction.card.number
        request.parameters["CVV"] = transaction.card.cvv
        request.parameters["Reference"] = transaction.reference
        if(transaction.card.pin != nil) {
            request.parameters["CardPin"] = transaction.card.pin
        }
        
        return service.chargeCard(request: request)
        .flatMap{
             result -> Observable<ApiResponse<ChargeCard>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
    }
    
    
    func verifyTransactionByReference(reference : String) -> Observable<ApiResponse<VerifyTransaction>> {
        
        return  service.verifyTransactionByReference(ref: reference)
        .flatMap{
             result -> Observable<ApiResponse<VerifyTransaction>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
        
    }
    
    func verifyCardOtp(transaction : Transaction) ->  Observable<ApiResponse<VerifyOtp>> {
        let request = ApiRequest()
        request.parameters["otp"] = transaction.otp
        request.parameters["reference"] = transaction.reference
        
        return  service.verifyCardOtp(request: request)
        .flatMap{
             result -> Observable<ApiResponse<VerifyOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
    }
    
    func verifyBankOtp(transaction : Transaction) -> Observable<ApiResponse<VerifyOtp>> {
        let request = ApiRequest()
        request.parameters["otp"] = transaction.otp
        request.parameters["reference"] = transaction.reference
        
        return service.verifyBankOtp(request: request)
        .flatMap{
             result -> Observable<ApiResponse<VerifyOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
    }
    
    func chargeBank(transaction : Transaction) -> Observable<ApiResponse<ChargeBank>> {
        let request = ApiRequest()
        request.parameters["BankCode"] = transaction.bankCode
        request.parameters["AccountNumber"] = transaction.accountNumber
        request.parameters["Reference"] = transaction.reference
        request.parameters["AccountName"] = transaction.accountName
        request.parameters["dateOfBirth"] = transaction.dateOfBirth
        request.parameters["bvn"] = transaction.bvn
        
        return service.chargeBank(request: request)
        .flatMap{
             result -> Observable<ApiResponse<ChargeBank>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
    }
    
    func enrollBankOtp(transaction : Transaction) -> Observable<ApiResponse<EnrollOtp>> {
        let request = ApiRequest()
        request.parameters["otp"] = transaction.otp
        request.parameters["reference"] = transaction.reference
        
        return service.enrollBankOtp(request: request)
        .flatMap{
             result -> Observable<ApiResponse<EnrollOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
        
    }
    
    func enrollCardOtp(transaction : Transaction) -> Observable<ApiResponse<EnrollOtp>> {
    
        let request = ApiRequest()
        request.parameters["reference"] = transaction.reference
        request.parameters["registeredPhoneNumber"] = transaction.card.phoneNumber
        request.parameters["cardModel"] = transaction.card.toJson
        
        return service.enrollCardOtp(request: request)
        .flatMap{
             result -> Observable<ApiResponse<EnrollOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
        
    }
    
    
    
}
