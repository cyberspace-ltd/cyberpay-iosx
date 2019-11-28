//
//  VerifyOtp.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

internal struct VerifyOtp : Decodable {
    var reference : String? = nil
    var processorReference : String? = nil
    var status : String? = nil
    var redirectUrl : String? = nil
    var message : String? = nil
    var reason: String? = nil
    var responseAction : String? = nil
}
