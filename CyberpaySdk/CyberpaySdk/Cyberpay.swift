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



/**
 The Cyberpay iOS SDK, used for integrating payments into your solution
*/
public class CyberpaySdk {
    
    
    /**
      The shared instance of the `CyberpaySdk`. This ensures that only *one instance of the SDK is running*
     */
    public static let shared = CyberpaySdk()
    
    internal  var key : String = "*"
    internal  var envMode = Mode.Debug
    private var maskView = ProgressMaskView()
    internal var isServerTransaction =  false
    internal var autoGenerateMerchantReference = false
    var bottomSheetController : UIViewController = UIViewController()
    
    private var repository: TransactionRepository = TransactionRepositoryImpl()
    private var progressController = UIViewController()
    
    private var initializedTransaction = Transaction()
    
    private func clearTempAdvice(){
        TransactionRepositoryImpl.bankAdvice = nil
        TransactionRepositoryImpl.cardAdvice = nil
    }
    
    
    
    
    private func showProgress(message: String = "")
    {
        if message.isEmpty {
            LoadingIndicatorView.show()
        }
        else {
            LoadingIndicatorView.show(message)
        }
    }
    
    private func dismissProgress(){
        LoadingIndicatorView.hide()
    }
    
    private init(){
        
    }
    
    
    /**
     Use this  `initialise` function to  begin integration with the`CyberpaySdk` in Debug `mode`
     
     - parameter integrationKey: The integration key gotten from the Cyberpay merchant portal.
     
     - warning:  Only use this to initialize the `CyberpaySdk` during testing
     
     # Example #
     ```
     initialise(with: "xyz123")
     ```
     */
    
    public func initialise(with integrationKey : String) -> Self {
        key = integrationKey
        
        return self
    }
    
    
    /**
     Use this `initialise` function to begin the `CyberpaySdk` integration
     
     - parameter integrationKey: The integration key gotten from the Cyberpay merchant portal.
     - parameter mode: The current mode of the platform. By default it is `Mode.Debug`. It can also be `Mode.Live`
     
     
     # Notes: #
     1. Before moving to production, ensure that  `mode` is set to `Mode.Live`
     
     # Example #
     ```
     initialise(with: "xyz123", mode: .Live)
     ```
     
     */
    
    public func initialise(with integrationKey : String, mode : Mode) -> Self{
        envMode = mode
        key = integrationKey
        
        return self
    }
    
    /**
     Use this `setTransaction` function to create a new transaction object
     
     
     - parameter customerEmail: This is the email of the customer you are creating the transaction for. This is optional
     - parameter merchantRef: This is your merchant reference, you can add this  to check the transaction status  later for verification. This is optional
     - parameter amountInKobo: The amount of the transaction in Kobo
     
     # Notes: #
     1. Ensure this is called after the `CyberpaySdk.initialise` function
     
     # Example #
     ```
     setTransaction(amountInKobo: 5000)
     ```
     
     */
    
    public func setTransaction(forCustomerEmail customerEmail: String = "", withMerchantReference merchantRef: String = "", amountInKobo: Double ) -> Self {
        initializedTransaction.customerEmail = customerEmail
        initializedTransaction.amount = amountInKobo
        
        if merchantRef.isEmpty {
            initializedTransaction.merchantReference = UUID().uuidString
        }
        else {
            initializedTransaction.merchantReference = merchantRef
        }
        return self
    }
    
    /**
     Use this `continueTransactionFromServer` function to continue a transaction you have already set from the server.
     
     - parameter reference: This reference of the transaction set in the server
     
     # Notes: #
     1. Ensure this is called after the `CyberpaySdk.initialise` function
     2. After calling this function, you can proceed to call the `CyberpaySdk.serverDropInCheckout`
     
     # Example #
     ```
     continueTransactionFromServer(withReference: "xyz123")
     ```
     
     */
    
    public func continueTransactionFromServer(withReference reference: String ) -> Self {
        initializedTransaction.ref = reference
        return self
    }
    
    private func validate() throws {
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
            
            let otpView = PinPad(contentViewController: self.bottomSheetController, message: transaction.message, inputType: InputType.Otp) { (otp) in
                transaction.otp = otp
                self.verifyCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                
            }
            
            rootController.presentOnRoot(with: otpView)
            
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
            
            rootController.presentOnRoot(with: otpView)
            
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
            
            rootController.presentOnRoot(with: otpView)
            
        }
        
    }
    
    
    
    
    private func processSecure3dPayment(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                        onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        self.bottomSheetController = rootController
        
        DispatchQueue.main.async {
            
            if !transaction.returnUrl.isEmpty {
                
                DispatchQueue.main.async {
                    
                    let secure3dView = Secure3DViewController(rootController: self.bottomSheetController, transaction: transaction, onFinished: { (transaction) in
                        
                        self.repository.verifyTransactionByReference(reference: transaction.reference).subscribe(onNext: { (result) in
                            
                            transaction.message =  result.data!.message!
                            
                            switch(result.data?.status){
                            case "Successful", "Success":
                                onSuccess(transaction)
                                break
                                
                            default  :
                                onError( transaction, Exception.CyberpayException(message: result.data!.message!))
                                break
                                
                            }
                            
                            
                        }, onError: { (error) in
                            
                            onError(transaction, error)
                            
                        })
                        
                    }) { (errorMessage) in
                        onError(transaction, Exception.CyberpayException(message: errorMessage))
                        
                    }
                    
                    rootController.presentOnRoot(with: secure3dView)
                    
                    
                }
                
                
                
            } else {
                onError( transaction, Exception.CyberpayException(message: "The transaction did not contain a URL for 3DSecure "))
            }
            
        }
        
    }
    
    private func processMandateBankOtp(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                       onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.chargeCard(transaction: transaction)
            .subscribe(onNext: {
                result in
                
                switch(result.data?.status){
                case "Success", "Successful":
                    onSuccess(transaction)
                    break
                case "FinalOtp" :
                    DispatchQueue.main.async {
                        
                        let otpView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.Otp) { (otp) in
                            
                            transaction.otp = otp
                            self.enrollCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                            
                        }
                        rootController.presentOnRoot(with: otpView)
                        
                    }
                    break
                    
                default  :
                    onError( transaction, Exception.CyberpayException(message: result.data!.message!))
                    break
                    
                }
                
            }, onError: {
                error in
                onError(transaction,error)
            })
        
    }
    
    private func chargeCardWithoutPin(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                      onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.chargeCard(transaction: transaction)
            .subscribe(onNext: {
                result in
                
                if result.data?.reason != nil && !result.data!.reason!.isEmpty {
                    transaction.message = result.data?.reason ?? ""
                }
                else if result.data?.message != nil && !result.data!.message!.isEmpty {
                    transaction.message = result.data?.message ?? ""
                }
                switch(result.data?.status){
                    
                    
                case "Success", "Successful":
                    onSuccess(transaction)
                case "Otp" :
                    self.processCardOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    
                case "ProvidePin" :
                    DispatchQueue.main.async {
                        
                        let pinView = PinPad(contentViewController: self.bottomSheetController, message: transaction.message, inputType: InputType.Pin) { (pin) in
                            
                            transaction.card?.pin = pin
                            self.chargeCardWithPin(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                            
                        }
                        rootController.presentOnRoot(with: pinView)
                    }
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
    
    private func enrollBank(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                            onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.enrolBank(transaction: transaction)
            .subscribe(onNext: { (result) in
                transaction.message = result.data!.message!
                switch result.data?.status {
                case "Successful", "Success":
                    onSuccess(transaction)
                    break
                case "MandateOtp":
                    
                    DispatchQueue.main.async {
                        
                        let otpView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.BankOtp) { (otp) in
                            
                            transaction.otp = otp
                            self.processMandateBankOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                            
                        }
                        
                        rootController.presentOnRoot(with: otpView)
                        
                    }
                    
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
                    self.bottomSheetController = rootController
                    
                    DispatchQueue.main.async {
                        
                        let dobView = DateOfBirthView(contentViewController: self.bottomSheetController, message: result.data?.requiredParameters![0].message! ?? "") { (dob) in
                            
                            transaction.bankAccount?.dateOfBirth = dob
                            self.enrollBank(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                            
                        }
                        rootController.presentOnRoot(with: dobView)
                        
                    }
                    
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
                    
                    rootController.presentOnRoot(with: otpView)
                    
                }
                
                break
            case  "EnrollOtp":
                DispatchQueue.main.async {
                    
                    let otpView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.BankOtp) { (otp) in
                        
                        transaction.otp = otp
                        self.enrollBankOtp(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                        
                    }
                    
                    rootController.presentOnRoot(with: otpView)
                    
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
    
    /**
     Use this `dropInCheckout` function to initialize our Drop-In UI, with a new transaction
     
     - parameter rootController: This your controller that will call our interface.
     - parameter onSuccess: This returns if a transaction was successful. It returns a `Transaction` object.
     - parameter onError: This returns if a transaction failed . It returns a `Transaction` object, and an `Error` object.
     - parameter onValidate: Not neededt.
     
     - warning:
     Warning if a transaction reference has not been set, or you have not called the `CyberpaySdk.setTransaction` it throws an `Exception`
     
     
     # Notes: #
     1. This function should only be called after you have called the `CyberpaySdk.setTransaction` function
     
     # Example #
     ```
     dropInCheckout(rootController: self, onSuccess: {result in
     
     print(result.reference)
     
     }, onError: { (result, error) in
     print(error)
     
     }, onValidate: {result in
     
     })
     ```
     
     */
    
    public func dropInCheckout(rootController: UIViewController, onSuccess: @escaping (Transaction)->(),
                               onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        try! validate()
        initializedTransaction.key = self.key
        self.bottomSheetController = rootController
        
        showProgress(message: "Processing Transaction")
        
        createTransaction(rootController: self.bottomSheetController, transaction: initializedTransaction, onSuccess: { (transaction) in
            
            DispatchQueue.main.async {
                self.dismissProgress()
            }
            
            try! self.completeTransaction(rootController: self.bottomSheetController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
            
        }, onError: { (transaction, error) in
            
            DispatchQueue.main.async {
                self.dismissProgress()
            }
            onError(transaction, error)
            
        }) { (transaction) in
            DispatchQueue.main.async {
                self.dismissProgress()
            }
            onValidate(transaction)
            
        }
        
    }
    
    
    public func completeTransaction(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()) throws {
        try! validate()
        
        if transaction.reference.isEmpty {
            throw Exception.TransactionNotFoundException(message: "Transaction reference not found. Kindly set transaction before calling this method")
        }
        
        isServerTransaction =  false
        clearTempAdvice()
        transaction.key = key
        
        if (transaction.merchantReference?.isEmpty ?? true) && !autoGenerateMerchantReference {
            autoGenerateMerchantReference =  true
        }
        
        if autoGenerateMerchantReference {
            transaction.merchantReference =  UUID().uuidString
        }
        
        
        DispatchQueue.main.async {
            
            self.showProgress(message: "Processing Transaction")
            
            self.bottomSheetController = rootController
            
            
            
            let checkout = Checkout(transaction: transaction,rootController: self.bottomSheetController, onCardSubmit: { card in
                
                //create transaction
                DispatchQueue.main.async{
                    
                    self.showProgress( message: "Processing...")
                    
                    transaction.card = card
                    
                    try! self.processPayment(rootController: rootController, transaction: transaction, onSuccess: { (transaction) in
                        
                        DispatchQueue.main.async {
                            self.dismissProgress()
                            rootController.dismiss(animated: true, completion: nil)
                        }
                        onSuccess(transaction)
                        
                    }, onError: { (transaction, error) in
                        DispatchQueue.main.async {
                            self.dismissProgress()
                            if !self.autoGenerateMerchantReference {
                                rootController.dismiss(animated: true, completion: nil)
                                
                            }
                            onError(transaction, error)
                            
                        }
                        
                    }) { (transaction) in
                        DispatchQueue.main.async {
                            self.dismissProgress()
                        }
                        onValidate(transaction)
                        
                    }
                    
                    
                }
                
            },onBankSubmit: { bank in
                transaction.bankAccount = bank
                DispatchQueue.main.async{
                    self.showProgress()
                    
                    self.chargeBank(rootController: rootController, transaction: transaction, onSuccess: { (transaction) in
                        
                        DispatchQueue.main.async {
                            self.dismissProgress()
                            rootController.dismiss(animated: true, completion: nil)
                        }
                        onSuccess(transaction)
                    }, onError: { (transaction, error) in
                        
                        DispatchQueue.main.async {
                            self.dismissProgress()
                            
                            onError(transaction, error)
                            
                        }
                        
                    }) { (transaction) in
                        
                        DispatchQueue.main.async {
                            self.dismissProgress()
                            
                            
                        }
                        onValidate(transaction)
                        
                    }
                    
                }
                
                
            },onRedirect: { bankResponse in
                transaction.returnUrl = "\(bankResponse.externalRedirectUrl!)?reference=\(transaction.reference)"
                
                DispatchQueue.main.async{
                    self.dismissProgress()
                    
                    self.processSecure3dPayment(rootController: rootController, transaction: transaction, onSuccess: { (transaction) in
                        DispatchQueue.main.async {
                            self.dismissProgress()
                        }
                        onSuccess(transaction)
                    }, onError: { (transaction, error) in
                        DispatchQueue.main.async {
                            self.dismissProgress()
                        }
                        onError(transaction,error)
                    }) { (transaction) in
                        DispatchQueue.main.async {
                            self.dismissProgress()
                        }
                        onValidate(transaction)
                    }
                    
                    
                    
                }
                
            })
            
            rootController.presentOnRoot(with: checkout)
            
            
            
        }
        
    }
    
    /**
     Use the `serverDropInCheckout` function to initializes our Drop-In UI, if you've already set the transaction from the server
     
     - parameter rootController: This your controller that will call our interface.
     - parameter onSuccess: This returns if a transaction was successful. It returns a `Transaction` object.
     - parameter onError: This returns if a transaction failed . It returns a `Transaction` object, and an `Error` object.
     -  parameter onValidate: Not needed.
     
     - warning:
     Warning if a transaction reference has not been set, or you have not called the `CyberpaySdk.continueTransactionFromServer` it throws an `Exception`
     
     
     # Notes: #
     1. This function should only be called after you have called the `CyberpaySdk.continueTransactionFromServer` function
     
     # Example #
     ```
     serverDropInCheckout(rootController: self, onSuccess: {result in
     
     print(result.reference)
     
     }, onError: { (result, error) in
     print(error)
     
     }, onValidate: {result in
     
     })
     ```
     
     */
    public func serverDropInCheckout(rootController: UIViewController,onSuccess: @escaping (Transaction)->(),
                                     onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()) throws {
        try! validate()
        
        if initializedTransaction.reference.isEmpty {
            throw Exception.TransactionNotFoundException(message: "Transaction reference not found. Kindly set transaction before calling this method")
        }
        
        isServerTransaction =  true
        showProgress(message: "Processing Transaction")
        
        repository.getTransactionAdvice(transaction: initializedTransaction, channelCode: .Card)
            .subscribe(onNext: { (advice) in
                
                DispatchQueue.main.async {
                    self.dismissProgress()
                }
                
                self.initializedTransaction.amount =  advice.amount!
                self.initializedTransaction.charge = advice.charge!
                
                try! self.completeTransaction(rootController: rootController, transaction: self.initializedTransaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                
            }, onError: { (error) in
                DispatchQueue.main.async {
                    self.dismissProgress()
                }
                onError(self.initializedTransaction, error)
            })
        
        
    }
    
    private func processPayment(rootController: UIViewController, transaction: Transaction, onSuccess: @escaping (Transaction)->(),
                                onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->())  throws {
        
        if(transaction.card == nil){
            throw Exception.CardNotSetException(message: "Card Not Found. Card cannot be empty")
        }
        
        
        switch transaction.card.cardType {
        case .verve:
            transaction.message = "To ensure you own this card, kindly enter your pin to continue"
            DispatchQueue.main.async {
                
                let pinView = PinPad(contentViewController: self.bottomSheetController, inputType: InputType.Pin) { (pin) in
                    let pinString = String(pin)
                    transaction.card?.pin = pinString
                    self.chargeCardWithoutPin(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    
                }
                rootController.presentOnRoot(with: pinView)
                
            }
            break
        case .visa:
            
            if isServerTransaction {
                repository.updateTransactionClientType(transaction: transaction)
                    .subscribe(onNext: { (result) in
                        self.chargeCardWithoutPin(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
                    }, onError: {(error) in
                        onError(transaction,error)
                        
                    })
            }
            else {
                self.chargeCardWithoutPin(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
            }
            break
            
        default:
            self.chargeCardWithoutPin(rootController: rootController, transaction: transaction, onSuccess: onSuccess, onError: onError, onValidate: onValidate)
        }
        
        
        
    }
    
    
    
    
    
}

