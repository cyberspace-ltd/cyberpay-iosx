//
//  Transaction.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/27/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
public class Transaction {
    
    public var card : Card!
    internal var ref : String?
    public var type : TransactionType?
    public var merchantReference : String?
    internal var currency = "NGN"
    internal var returnUrl = "url"
    internal var channel = "None"
    public var description = "Cyberpay Transaction"
    public var amount = 0.0
    internal var otp = ""
    internal var key = ""
    public var charge : Double? = 0.0
    public var customerEmail = ""
    
    internal var bankCode: String? = ""
    internal var accountNumber : String? = ""
    internal var accountName : String? = ""
    public var dateOfBirth : String? = ""
    public var bvn : String? =  ""
    
    internal var clientType = "Mobile"
    public var splits : Array<Split> = Array()
    
    var message = ""
    
    public var amountToPay : String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "ig_NG")
        let priceString = currencyFormatter.string(from: NSNumber(value: (amount + charge!)/100))!
        
        return priceString
    }
    
    
    internal var bankAccount: BankAccount? = nil
    
    public var reference : String {
        return self.ref!
    }
    
    public init() {}
    
    
}
