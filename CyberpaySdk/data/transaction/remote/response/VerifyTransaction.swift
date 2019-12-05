//
//  VerifyTransaction.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

internal struct VerifyTransaction : Codable {
    var status : String? = nil
    var message : String? = nil
    var reference : String? = nil
}
