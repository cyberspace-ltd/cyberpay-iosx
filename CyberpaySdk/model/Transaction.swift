//
//  Transaction.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/27/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
class Transaction {
    
    var card : Card!
    internal var reference : String!
    var merchantReference : String!
    var currency = "NGN"
    var returnUrl = "url"
    var channel = "None"
    var description = "Cyberpay Transaction"
    var amount = 0.0
    internal var otp = ""
    internal var key = ""
    var charge : Double? = 0.0
    var customerEmail = ""
    var bankCode: String? = ""
    var accountNumber : String? = ""
    var accountName : String? = ""
    var dateOfBirth : String? = ""
    var bvn : String? =  ""
    internal var clientType = "Mobile"
}
