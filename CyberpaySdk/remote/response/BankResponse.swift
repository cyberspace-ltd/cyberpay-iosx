//
//  BankResponse.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

internal struct BankResponse : Codable {
    var id: Int? = 0
    var bankCode: String?  = ""
    var bankName: String?  = ""
    var isActive : Bool? = false
    var providerCode : Int?  = 0
//    var bankProviders : [Any]? = []
    var processingType : String? = ""
    var externalRedirectUrl : String? = ""
}
