//
//  CyberpaySdk.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/24/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

class CyberpaySdk {
    
    public static let INSTANCE = CyberpaySdk()
    private  var key : String!
    internal var envMode = Mode.Debug
    

    private init(){
        
    }
    
    public func initialise(intigrationKey : String){
        
    }
    
    func initialise(intigrationKey : String, mode : Mode){
        envMode = mode
    }
    
    private func validateKey(){
        
    }
    
    
    static func verifyCardOtp(transaction: Transaction, onSucess: @escaping (Transaction)->(),
                              onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->() ){
        
        
    }
    
    private func verifyBankOtp(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func processBankOtp(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func processCardOtp(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func processSecure3dPayment(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func chargeCardWithoutPin(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func chargeCardWithPin(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private static func enrollCardOtp(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func enrollBankOtp(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    public func chargeBank(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
           
    }
    
    public func createTransaction(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    public func getPayment(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    public func chargeCard(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    public  func checkoutTransaction(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
    private func processPayment(transaction: Transaction, onSucess: @escaping (Transaction)->(),
    onError: @escaping (Transaction, Error)->(), onValidate: @escaping (Transaction)->()){
        
    }
    
}
