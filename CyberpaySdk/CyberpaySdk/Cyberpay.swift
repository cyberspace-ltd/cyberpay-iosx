//
//  Cyberpay.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 19/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import FittedSheets

/// A protocol for observing the status of your transactions within the `CyberpaySdk`
public protocol CyberpayDelegate {
    
    /// Called when 3DS  authentication for the transaction is completed.
    ///
    /// - Parameters:
    ///   - for transaction: The Transaction that the  `CyberpaySdk` was handling.
    func onCyberpayDidReturnWithSuccess(for transaction: Transaction)
    
    func onCyberpayDidReturnWithError(for transaction: Transaction?, withError error: Error)
    
    func onCyberpayDidReturnWithValidate(for transaction: Transaction)
    
    
}

public class CyberpaySdk {
    
    
    public static let INSTANCE = CyberpaySdk()
    internal  var key : String = "*"
    internal var envMode = Mode.Debug
    private var maskView = ProgressMaskView()
    internal var isServerTransaction =  false
    internal var autoGenerateMerchantReference = false
    var bottomSheetController : UIViewController = UIViewController()
    
    private var repository: TransactionRepository = TransactionRepositoryImpl()
    private var progressController = UIViewController()
    private var delegate: CyberpayDelegate? = nil
    
    private func clearTempAdvice(){
        TransactionRepositoryImpl.bankAdvice = nil
        TransactionRepositoryImpl.cardAdvice = nil
    }
    
    private func showProgress(message: String)
    {
        LoadingIndicatorView.show(message)
    }
    
    private func dismissProgress(){
        LoadingIndicatorView.hide()
    }
    
    private init(){
        
    }
    
    public func initialise(integrationKey : String){
        key = integrationKey
    }
    
    public func initialise(integrationKey : String, mode : Mode){
        envMode = mode
        key = integrationKey
    }
    
    private func validate() throws {
        if(delegate == nil){
            throw Exception.InvalidIntegrationException(message: "CyberpayDelegate has not been initialised!")
        }
        
        if(key=="*"){
            throw Exception.SDKNotInitializedException(message: "Cyberpay sdk has not been initialised!")
        }
        
        if(key == "") {
            throw Exception.InvalidIntegrationException(message: "Invalid Integration key Found!")
        }
    }
    
    
    private func verifyCardOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping(Transaction)->(),
                               onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->() ){
        repository.verifyCardOtp(transaction: transaction)
            .subscribe(onNext: { (result) in
                transaction.message = result.data!.message!
                switch result.data?.status {
                case "Successful", "Success":
                    onSuccess(transaction)
                    break
                default :
                    onError(transaction, Exception.CyberpayException(message: result.data!.reason!) )
                    break
                }
                
            }, onError: { (error) in
                onError(transaction, error)
                
            })
        
        
    }
    
    private func verifyBankOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                               onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.verifyBankOtp(transaction: transaction)
            .subscribe(onNext: { (result) in
                transaction.message = result.data!.message!
                switch result.data?.status {
                case "Successful", "Success":
                    onSuccess(transaction)
                    break
                default :
                    onError(transaction, Exception.CyberpayException(message: result.data!.reason!) )
                    break
                }
                
            }, onError: { (error) in
                onError(transaction, error)
                
            })
        
    }
    
    private func processCardOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping(Transaction)->(),
                                onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        self.bottomSheetController = rootController
        
        DispatchQueue.main.async {
            
            let otpView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.Otp) { (otp) in
                
                transaction.otp = otp
                self.verifyCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                
            }
            
            rootController.present(otpView, animated: true, completion: nil)
            
        }
        
    }
    
    private func processBankOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping(Transaction)->(),
                                onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        self.bottomSheetController = rootController
        
        DispatchQueue.main.async {
            
            let otpView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.BankOtp) { (otp) in
                
                transaction.otp = otp
                self.verifyBankOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                
            }
            
            rootController.present(otpView, animated: true, completion: nil)
            
        }
        
    }
    
    private func processEnrollCardOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping(Transaction)->(),
                                      onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        self.bottomSheetController = rootController
        
        DispatchQueue.main.async {
            
            let otpView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.Otp) { (otp) in
                
                transaction.otp = otp
                self.enrollCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                
            }
            
            rootController.present(otpView, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    private func processSecure3dPayment(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                        onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        self.bottomSheetController = rootController
        
        DispatchQueue.main.async {
            
            if !transaction.returnUrl.isEmpty {
                let secure3dView =  Secure3DViewController(nibName: nil, bundle: nil)
                rootController.present(secure3dView, animated: true)
                secure3dView.initialize(with: transaction)
                
            } else {
                onError( transaction, Exception.CyberpayException(message: "The transaction did not contain a URL for 3DSecure "))
            }
            
        }
        
    }
    
    private func chargeCardWithoutPin(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                      onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.chargeCard(transaction: transaction)
            .subscribe(onNext: {
                result in
                
                switch(result.data?.status){
                case "Success", "Successful":
                    onSuccess(transaction)
                case "Otp" :
                    self.processCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    
                case "ProvidePin" :
                    fatalError("Not Implemented")
                    
                case "EnrollOtp" :
                    self.processEnrollCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    
                    
                case "ProcessACS", "Secure3D" , "Secure3DMpgs" :
                    transaction.returnUrl = (result.data?.redirectUrl)!
                    self.processSecure3dPayment(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    
                default  :
                    onError( transaction, Exception.CyberpayException(message: result.data!.message!))
                }
                //onSuccess(transaction)
                
            }, onError: {
                error in
                onError(transaction,error)
            })
        
    }
    
    private func chargeCardWithPin(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                   onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.chargeCard(transaction: transaction)
            .subscribe(onNext: {
                result in
                
                switch(result.data?.status){
                case "Success", "Successful":
                    onSuccess(transaction)
                case "Otp" :
                    self.processCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    
                case "ProvidePin" :
                    fatalError("Not Implemented")
                    
                case "EnrollOtp" :
                    self.processEnrollCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    
                    
                case "ProcessACS", "Secure3D" , "Secure3DMpgs" :
                    transaction.returnUrl = (result.data?.redirectUrl)!
                    self.processSecure3dPayment(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    
                default  :
                    onError( transaction, Exception.CyberpayException(message: result.data!.message!))
                }
                //onSuccess(transaction)
                
            }, onError: {
                error in
                onError(transaction,error)
            })
        
    }
    
    private  func enrollCardOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.enrollCardOtp(transaction: transaction)
            .subscribe(onNext: { (result) in
                transaction.message = result.data!.message!
                switch result.data?.status {
                case "Successful", "Success":
                    onSuccess(transaction)
                    break
                case "Otp":
                    self.processCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    break
                case "ProvidePin":
                    self.chargeCardWithPin(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    break
                default :
                    onError(transaction, Exception.CyberpayException(message: result.message!) )
                    break
                }
                
            }, onError: { (error) in
                onError(transaction, error)
                
            })
    }
    
    private func enrollBankOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                               onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.enrollBankOtp(transaction: transaction)
            .subscribe(onNext: { (result) in
                transaction.message = result.data!.message!
                switch result.data?.status {
                case "Successful", "Success":
                    onSuccess(transaction)
                    break
                case "Otp":
                    self.processBankOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    break
                default :
                    onError(transaction, Exception.CyberpayException(message: result.message!) )
                    break
                }
                
            }, onError: { (error) in
                onError(transaction, error)
                
            })
        
    }
    
    private func processBankFinalOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                     onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.finalBankOtp(transaction: transaction)
            .subscribe(onNext: { (result) in
                transaction.message = result.data!.message!
                switch result.data?.status {
                case "Successful", "Success":
                    onSuccess(transaction)
                    break
                    
                default :
                    onError(transaction, Exception.CyberpayException(message: result.data!.message!) )
                    break
                }
                
            }, onError: { (error) in
                onError(transaction, error)
                
            })
        
    }
    
    private func chargeBank(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                            onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        transaction.type = TransactionType.Bank
        try! validate()
        
        repository.chargeBank(transaction: transaction).subscribe(onNext: { (result) in
            transaction.message = result.data!.message!
            switch result.data?.status {
            case "Success", "Successful" :
                onSuccess(transaction)
                break
            case  "OtherDetails":
                
                switch result.data?.requiredParameters![0].param {
                case "dob":
                    /// TODO: BUILD Date of Birth View
                    break
                case "bvn":
                    /// TODO:  Add BVN implementationj
                    
                    break
                default:
                    
                    
                    break
                    
                }
                
            case  "FinalOtp":
                
                DispatchQueue.main.async {
                    
                    let otpView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.Otp) { (otp) in
                        
                        transaction.otp = otp
                        self.processBankFinalOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                        
                    }
                    
                    rootController.present(otpView, animated: true, completion: nil)
                    
                }
                
                break
            case  "EnrollOtp":
                DispatchQueue.main.async {
                    
                    let otpView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.Otp) { (otp) in
                        
                        transaction.otp = otp
                        self.enrollBankOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                        
                    }
                    
                    rootController.present(otpView, animated: true, completion: nil)
                    
                }
                
                break
            case  "Otp":
                self.processBankOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                break
            default:
                onError(transaction, Exception.CyberpayException(message: result.data!.message!) )
                break
                
            }
        }, onError: { (error) in
            
            onError(transaction, error)
            
        })
        
        
    }
    
    public func createTransaction(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                  onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        transaction.key = self.key
        
        // code for merchant reference auto generate here
        
        repository.beginTransaction(transaction: transaction)
            .subscribe(onNext: {
                result in
                
                print("begin Transaction, on Next \(String(describing: result.data))")
                
                transaction.ref = result.data?.transactionReference
                transaction.charge = result.data?.charge
                onSuccess(transaction)
                
                
            }, onError: {
                error in
                onError(transaction,error)
            })
        
        
    }
    
    public func getPayment(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                           onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->())  {
        
        transaction.type = TransactionType.Card
        
        self.createTransaction(rootController: rootController, transaction: transaction, onSuccess: {
            result in
            
            try! self.processPayment(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
            
        }, onError: onError, onValidate: onValidate)
        
        
        
    }
    
    public func chargeCard(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                           onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        try! validate()
        clearTempAdvice()
        transaction.type = TransactionType.Card
        try! self.processPayment(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
    }
    
    
    
    public func checkoutTransaction(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        try! validate()
        transaction.key = self.key
        self.bottomSheetController = rootController
        
        
        
        DispatchQueue.main.async {
            
            let checkout = Checkout(transaction: transaction,rootController: self.bottomSheetController, onCardSubmit: { card in
                
                //create transaction
                DispatchQueue.main.async{
                    
                    print("card transationc")
                    print(Thread.current.nextSequenceId())
                    self.showProgress( message: "Processing...")
                    
                    self.createTransaction(rootController: rootController, transaction: transaction, onSuccess: { (trans) in
                        self.dismissProgress()
                        
                    }, onError: { (trans, err) in
                        self.dismissProgress()
                        onError(trans,err)
                        
                    }) { (trans) in
                        self.dismissProgress()
                        onValidate(trans)
                    }
                    
                }
                
                
                
            },
                                    onBankSubmit: { bank in
                                        
            },
                                    onRedirect: { bank in
                                        
            })
            
            rootController.present(checkout, animated: true, completion: nil)
            
            //self.showProgress(controller: pin, message: "Proccessing...")
            
            
        }
        
    }
    
    public func completeCheckoutTransaction(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                            onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()) throws {
        try! validate()
        
        if transaction.reference.isEmpty {
            throw Exception.TransactionNotFoundException(message: "Transaction reference not found. Kindly set transaction before calling this method")
        }
        
        isServerTransaction =  true
        showProgress(message: "Processing Transaction")
        
        fatalError("Not Implemented")
        
        
    }
    
    private func processPayment(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->())  throws {
        
        if(transaction.card == nil){
            throw Exception.CardNotSetException(message: "Card Not Found. Card cannot be empty")
        }
        
        
        if(transaction.card.cardType == SwiftLuhn.CardType.verve){
            
        }
            
        else {
            
        }
        
    }
    
    
    
    
    
    
}

extension CyberpaySdk : Secure3DControllerDelegate {
    
    
    public func secure3dViewController(_ secureDsView: Secure3DViewController, didComplete authenticated: Bool, for transaction: Transaction) {
        
        repository.verifyTransactionByReference(reference: transaction.reference).subscribe(onNext: { (result) in
            transaction.message = result.data!.message!
            
            switch result.data?.status {
            case "Successful", "Success":
                self.delegate?.onCyberpayDidReturnWithSuccess(for: transaction)
                break
            default :
                self.delegate?.onCyberpayDidReturnWithError(for: transaction, withError: Exception.CyberpayException(message: result.message!))
                break
            }
            
        }, onError: { error in
            self.delegate?.onCyberpayDidReturnWithError(for: transaction, withError: error)
            
        })
    }
    
    public func secure3dViewController(_ secureDsView: Secure3DViewController, didError error: String, for transaction: Transaction) {
        self.delegate?.onCyberpayDidReturnWithError(for: transaction, withError: Exception.CyberpayException(message: error))
        
    }
    
    public func secure3dViewControllerDidCancel(_ secureDsView: Secure3DViewController) {
        self.delegate?.onCyberpayDidReturnWithError(for: nil, withError: Exception.CyberpayException(message: "3DSecure authentication cancelled has been cancelled."))
    }
}
