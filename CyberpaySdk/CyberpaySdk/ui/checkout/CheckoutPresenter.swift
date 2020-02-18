//
//  CheckoutPresenter.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

internal class CheckoutPresenter: CheckoutViewPresenter {
 
    
    weak var view: CheckoutView?
    private var transactionRepository = TransactionRepository()
    
    private var bankRepository = BankRepository()

    private var isLoading = false
    var paymentOption = TransactionType.Card


    required init(view: CheckoutView) {
        self.view = view
    }
    
    func viewDidLoad() {
      print("View notifies the Presenter that it has loaded.")

     }
     
    
    func bankPay() {
        paymentOption = TransactionType.Bank
        self.view?.onBankPay()
    }
    
    func cardPay() {
        paymentOption =  TransactionType.Card
        self.view?.onCardPay()

    }
    
    func getAccountName(bankCode: String, account: String) {
        
        bankRepository.getAccountName(bankCode: bankCode, accountNo: account)
        .subscribe(onNext: { (result) in
            self.view?.onAccountName(account: result.data!)
               }, onError: { (error) in
                self.view?.onError(message: error.localizedDescription)
            })

    }
    
    
    func getCardTransactionAdvice(transaction: Transaction) {
        transactionRepository.getCardTransactionAdvice(transaction: transaction)?.subscribe(onNext: { (advice) in
        
            self.view?.onUpdateAdvice(advice: advice)
            
        }, onError: { (error) in
            self.disablePay()
        })
    }
    
    func getBankTransactionAdvice(transaction: Transaction) {
        transactionRepository.getBankTransactionAdvice(transaction: transaction)?.subscribe(onNext: { (advice) in
        
            self.view?.onUpdateAdvice(advice: advice)
            
        }, onError: { (error) in
            self.disablePay()
        })
    }
    
    func cancelTransaction(transaction: Transaction) {
        transactionRepository.cancelTransaction(transaction: transaction)?
        .subscribe(onNext: { (result) in
            transaction.message =  result.message!
            self.view?.onCancelTransaction(transaction: transaction)
        }, onError: { (error) in
            self.view?.onCancelTransactionError(transaction: transaction)
        })
    }
    
    func disablePay() {
        self.view?.onDisablePay()

    }
    
    func enablePay() {
        self.view?.onEnablePay()
    }
    
}
