//
//  Bank.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/16/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

internal class Bank{
    var id = 0
    var bankCode = ""
    var bankName = ""
    var isActive : Bool? = false
    var providerCode : Int?  = 0
    var bankProviders : Array<Any>? = nil
    var processingType : String? = ""
    var externalRedirectUrl : String? = ""
}
