//
//  SetTransaction.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

internal struct SetTransaction : Codable {
    var transactionReference : String?
    var charge : Double?
    var redirectUrl : String?
}
