//
//  EnrollBank.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

internal struct EnrollBank: Codable {
    var status: String? = ""
    var message: String? = ""
    var responseAction: String? = nil
    var adviceTransactionType: String? = nil
}
