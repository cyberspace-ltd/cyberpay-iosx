//
//  TransactionServiceProtocol.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal protocol TransactionServiceProtocol {

    func beginTransaction(request : ApiRequest) -> Observable<ApiResponse<SetTransaction>>
    func chargeCard (request: ApiRequest) ->  Observable<ApiResponse<ChargeCard>>
    func verifyTransactionByReference(reference: String) -> Observable<ApiResponse<VerifyTransaction>>
    func verifyTransactionByMerchantReference(merchantReference: String) -> Observable<ApiResponse<VerifyMerchantTransaction>>
    func verifyCardOtp (request: ApiRequest) -> Observable<ApiResponse<VerifyOtp>>
    func verifyBankOtp (request: ApiRequest) -> Observable<ApiResponse<VerifyOtp>>
    func chargeBank (request: ApiRequest) -> Observable<ApiResponse<ChargeBank>>
    func enrollBankOtp(request : ApiRequest) -> Observable<ApiResponse<EnrollOtp>>
    func enrollCardOtp(request : ApiRequest) -> Observable<ApiResponse<EnrollOtp>>
    func enrolBank(request: ApiRequest) -> Observable<ApiResponse<EnrollBank>>
    func finalBankOtp(request: ApiRequest) -> Observable<ApiResponse<VerifyOtp>>
    func mandateBankOtp(request: ApiRequest) -> Observable<ApiResponse<EnrollOtp>>
    func getCardTransactionAdvice(request: ApiRequest) -> Observable<Advice>
    func getBankTransactionAdvice(request: ApiRequest) -> Observable<Advice>
    func updateTransactionClientType(request: ApiRequest) -> Observable<ApiResponse<EnrollOtp>>
    func cancelTransaction(transaction : Transaction,request: ApiRequest) -> Observable<ApiResponse<AnyCodable>>

}
