//
//  TransactionRepository.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

internal protocol TransactionRepository {
    
    func beginTransaction(transaction: Transaction) -> Observable<ApiResponse<SetTransaction>>
    func chargeCard (transaction:Transaction) ->  Observable<ApiResponse<ChargeCard>>
    func verifyTransactionByReference(reference: String) -> Observable<ApiResponse<VerifyTransaction>>
    func verifyTransactionByMerchantReference(merchantReference: String) -> Observable<ApiResponse<VerifyMerchantTransaction>>
    func verifyCardOtp (transaction: Transaction) -> Observable<ApiResponse<VerifyOtp>>
    func verifyBankOtp (transaction: Transaction) -> Observable<ApiResponse<VerifyOtp>>
    func chargeBank (transaction: Transaction) -> Observable<ApiResponse<ChargeBank>>
    func enrollBankOtp(transaction: Transaction) -> Observable<ApiResponse<EnrollOtp>>
    func enrollCardOtp(transaction: Transaction) -> Observable<ApiResponse<EnrollOtp>>
    func enrolBank(transaction: Transaction) -> Observable<ApiResponse<EnrollBank>>
    func finalBankOtp(transaction: Transaction) -> Observable<ApiResponse<VerifyOtp>>
    func mandateBankOtp(transaction: Transaction) -> Observable<ApiResponse<EnrollOtp>>
    func updateTransactionClientType(transaction: Transaction) -> Observable<ApiResponse<EnrollOtp>>
    func cancelTransaction(transaction: Transaction) -> Observable<ApiResponse<AnyCodable>>
    
     func getTransactionAdvice(transaction: Transaction, channelCode: ChannelCode) ->  Observable<Advice>
}
