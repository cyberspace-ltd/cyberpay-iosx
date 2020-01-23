//
//  CyberpaySdk.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/24/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import UIKit
import FittedSheets

public class CyberpaySdk {
    
    public static let INSTANCE = CyberpaySdk()
    private  var key : String = "*"
    internal var envMode = Mode.Debug
    private var maskView = ProgressMaskView()
   
    var bottomSheetController : UIViewController = UIViewController()
    
    private var repository = TransactionRepository()
    private var progressController = UIViewController()
    
    private func showProgress(controller: UIViewController,message: String)
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
    }
    
    private func dismissProgress(){
        maskView.hideIn(second: 1.0, uninstall: true)
    }

    private init(){
        
    }
    
    public func initialise(intigrationKey : String){
        key = intigrationKey
    }
    
    func initialise(intigrationKey : String, mode : Mode){
        envMode = mode
        key = intigrationKey
    }
    
    private func validateKey() throws {
        if(key=="*"){
            throw Exception.SDKNotInitializedException(message: "Cyberpay sdk has been initialised!")
        }
        
        if(key == "") {
            throw Exception.InvalidIntegrationException(message: "Invalid Integration key Found!")
        }
    }
    
    
    static func verifyCardOtp(rootController: UIViewController, transaction: Transaction, onSucess: @escaping(Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->() ){
        
    
    }
    
    private func verifyBankOtp(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func processBankOtp(rootController: UIViewController, transaction: Transaction, onSucess: @escaping(Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func processCardOtp(rootController: UIViewController, transaction: Transaction, onSucess: @escaping(Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func processSecure3dPayment(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func chargeCardWithoutPin(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        repository.chargeCard(transaction: transaction)
        .subscribe(onNext: {
            result in
        
            switch(result.data?.status){
            case "Success", "Successful":
                onSucess(transaction)
                
            case "Otp" :
                print("")
                
            case "ProvidePin" :
                print("")
                
            case "EnrollOtp" :
                print("")
                
            case "ProcessACS", "Secure3D" , "Secure3DMpgs" :
               transaction.returnUrl = (result.data?.redirectUrl)!
            
            default  :
                onError( transaction, Exception.CyberpayException(message: result.message!))
            }
            //onSucess(transaction)
            
        }, onError: {
            error in
            onError(transaction,error)
        })
        
    }
    
    private func chargeCardWithPin(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private static func enrollCardOtp(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func enrollBankOtp(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func chargeBank(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
           
    }
    
    public func createTransaction(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        transaction.key = self.key
        
        // code for merchant reference auto generate here
    
        repository.beginTransaction(transaction: transaction)
            .subscribe(onNext: {
                result in
                transaction.ref = result.data?.transactionReference
                transaction.charge = result.data?.charge
                onSucess(transaction)
                
              
            }, onError: {
                error in
                onError(transaction,error)
            })
         
                
    }
    
    public func getPayment(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()) throws {
        
        transaction.type = TransactionType.Card
        
        self.createTransaction(rootController: rootController, transaction: transaction, onSucess: {
            result in
            
           //try self.processPayment(rootController: rootController, transaction: transaction, onSucess: onSucess, onError: onError, onValidate: onValidate)
            
        }, onError: onError, onValidate: onValidate)
        
        
        
    }
    
    public func chargeCard(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    public func checkoutTransaction(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
        transaction.key = self.key
        self.bottomSheetController = rootController
        
        
        
        DispatchQueue.main.async {
                        
          let checkout = Checkout(transaction: transaction,rootController: self.bottomSheetController, onCardSubmit: { card in
              
            //create transaction
            DispatchQueue.main.async{
                
            print("card transationc")
                print(Thread.current.nextSequenceId())
            //self.showProgress(controller: self.bottomSheetController, message: "Processing...")
                
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
    
    public func completeCheckoutTransaction(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func processPayment(rootController: UIViewController, transaction: Transaction, onSucess: @escaping (Transaction)->(),
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
