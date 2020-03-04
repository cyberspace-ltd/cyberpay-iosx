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

internal class TransactionRepositoryImpl : TransactionRepository {

    let service = TransactionService()
    static var cardAdvice: Advice? = nil
    static var bankAdvice: Advice? = nil
    
    
    private func setCardAdvice(ad: Advice) -> Observable<Advice> {
        TransactionRepositoryImpl.cardAdvice = ad
        return Observable.just(ad)
    }
    
    private func setBankAdvice(ad: Advice) -> Observable<Advice> {
        TransactionRepositoryImpl.cardAdvice = ad
        return Observable.just(ad)
    }
    
    func getTransactionAdvice(transaction: Transaction, channelCode: ChannelCode)->  Observable<Advice> {
        
        var channel: String
        switch channelCode {
        case ChannelCode.Card:
            channel = "Card"
            break
        case ChannelCode.BankAccount:
            channel = "BankAccount"
            break
        }
        
        return service.getTransactionAdvice(transaction: transaction, channelCode: channel)
            .flatMap { result ->  Observable<Advice>  in
                if result.succeeded  {
                    switch channelCode {
                    case ChannelCode.Card:
                        return self.setCardAdvice(ad: result.data!)
                        
                    case ChannelCode.BankAccount:
                        return self.setBankAdvice(ad: result.data!)
                        
                    }
                }
                else {
                    return Observable.error(Exception.CyberpayException(message: result.message!))
                }
                
        }
    }
    
    func cancelTransaction(transaction: Transaction) -> Observable<ApiResponse<AnyCodable>> {
        
        
        let request = ApiRequest()
        request.parameters["reference"] = transaction.reference
        request.parameters["registeredPhoneNumber"] = transaction.card.phoneNumber
        request.parameters["cardModel"] = transaction.card.toJson
        
        return service.cancelTransaction(transaction: transaction, request: request)
            .flatMap{
                result -> Observable<ApiResponse<AnyCodable>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
                
        }
        
        
    }
    
    
    
    func updateTransactionClientType(transaction: Transaction) -> Observable<ApiResponse<EnrollOtp>> {
        let request = ApiRequest()
        request.parameters["reference"] = transaction.reference
        return service.updateTransactionClientType(request: request)
            .flatMap{
                result -> Observable<ApiResponse<EnrollOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
                
        }
        
        
    }
    
    
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
        
        return service.beginTransaction(request: request)
            .flatMap{
                result -> Observable<ApiResponse<SetTransaction>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
        
    }
    
    
    func enrolBank(transaction: Transaction) -> Observable<ApiResponse<EnrollBank>> {
        let request = ApiRequest()
        
        request.parameters["bankCode"] = transaction.bankAccount?.bank?.bankCode
        request.parameters["accountNumber"] = transaction.bankAccount?.accountNumber
        request.parameters["bvn"] = transaction.bankAccount?.bvn
        request.parameters["accountName"] = transaction.bankAccount?.accountName
        request.parameters["Reference"] = transaction.reference
        request.parameters["dateOfBirth"] = transaction.bankAccount?.dateOfBirth
        
        return service.enrolBank(request: request)
            .flatMap{
                result -> Observable<ApiResponse<EnrollBank>> in
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
        
        return  service.verifyTransactionByReference(reference: reference)
            .flatMap{
                result -> Observable<ApiResponse<VerifyTransaction>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.data!.message!))
        }
        
    }
    
    func verifyTransactionByMerchantReference(merchantReference: String) -> Observable<ApiResponse<VerifyMerchantTransaction>> {
        return  service.verifyTransactionByMerchantReference(merchantReference: merchantReference)
            .flatMap{
                result -> Observable<ApiResponse<VerifyMerchantTransaction>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.message!))
        }
    }
    
    
    func verifyCardOtp(transaction : Transaction) ->  Observable<ApiResponse<VerifyOtp>> {
        let request = ApiRequest()
        request.parameters["otp"] = transaction.otp
        request.parameters["reference"] = transaction.reference
        request.parameters["card"] = transaction.card.toJson
        
        return  service.verifyCardOtp(request: request)
            .flatMap{
                result -> Observable<ApiResponse<VerifyOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.data?.message ?? result.message!))
        }
    }
    
    func verifyBankOtp(transaction : Transaction) -> Observable<ApiResponse<VerifyOtp>> {
        let request = ApiRequest()
        request.parameters["otp"] = transaction.otp
        request.parameters["reference"] = transaction.reference
        
        return service.verifyBankOtp(request: request)
            .flatMap{
                result -> Observable<ApiResponse<VerifyOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.data?.message ?? result.message!))
        }
    }
    
    
    
    func finalBankOtp(transaction: Transaction) -> Observable<ApiResponse<VerifyOtp>> {
        let request = ApiRequest()
        request.parameters["otp"] = transaction.otp
        request.parameters["reference"] = transaction.reference
        
        return service.finalBankOtp(request: request)
            .flatMap{
                result -> Observable<ApiResponse<VerifyOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.data?.message ?? result.message!))
        }
        
    }
    
    func mandateBankOtp(transaction: Transaction) -> Observable<ApiResponse<EnrollOtp>> {
         let request = ApiRequest()
              request.parameters["otp"] = transaction.otp
              request.parameters["reference"] = transaction.reference
              
              return service.mandateBankOtp(request: request)
                  .flatMap{
                      result -> Observable<ApiResponse<EnrollOtp>> in
                      return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.data?.message ?? result.message!))
              }
        
    }
    
    
    func chargeBank(transaction : Transaction) -> Observable<ApiResponse<ChargeBank>> {
        let request = ApiRequest()
        request.parameters["BankCode"] = transaction.bankAccount?.bank?.bankCode
         request.parameters["AccountNumber"] = transaction.bankAccount?.accountNumber
         request.parameters["bvn"] = transaction.bankAccount?.bvn
         request.parameters["AccountName"] = transaction.bankAccount?.accountName
         request.parameters["Reference"] = transaction.reference
         request.parameters["dateOfBirth"] = transaction.bankAccount?.dateOfBirth
        
        return service.chargeBank(request: request)
            .flatMap{
                result -> Observable<ApiResponse<ChargeBank>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.data?.message ?? result.message!))
        }
    }
    
    func enrollBankOtp(transaction : Transaction) -> Observable<ApiResponse<EnrollOtp>> {
        let request = ApiRequest()
        request.parameters["otp"] = transaction.otp
        request.parameters["reference"] = transaction.reference
        
        return service.enrollBankOtp(request: request)
            .flatMap{
                result -> Observable<ApiResponse<EnrollOtp>> in
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.data?.message ?? result.message!))
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
                return result.succeeded ? Observable.just(result) : Observable.error(Exception.CyberpayException(message: result.data?.message ?? result.message!))
        }
        
    }
    
    
    
}

