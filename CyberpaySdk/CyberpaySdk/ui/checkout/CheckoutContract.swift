//
//  CheckoutProtocol.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

internal protocol CheckoutViewPresenter {
    
    init(view: CheckoutView)
    func loadBanks()
    func viewDidLoad()
    func bankPay()
    func cardPay()
    func getAccountName(bankCode: String, account: String)
    func getCardTransactionAdvice(transaction: Transaction)
    func getBankTransactionAdvice(transaction: Transaction)
    func cancelTransaction(transaction: Transaction)
    func disablePay()
    func enablePay()
    
}

protocol CheckoutView: class {
    
    func onError(message: String)
    func onBankPay()
    func onCardPay()
    func onLoad()
    func onLoadComplete(banks: Array<BankResponse>)
    func onAccountName(account: AccountResponse)
    func onUpdateAdvice(advice: Advice)
    func onCancelTransaction(transaction: Transaction)
    func onCancelTransactionError(transaction: Transaction)
    func onDisablePay()
    func onEnablePay()
    
}
