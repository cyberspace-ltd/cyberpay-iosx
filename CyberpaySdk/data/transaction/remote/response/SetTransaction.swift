//
//  SetTransaction.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

internal struct SetTransaction : Decodable {
    var transactionReference : String?
    var charge : Int?
    var redirectUrl : String?
}
