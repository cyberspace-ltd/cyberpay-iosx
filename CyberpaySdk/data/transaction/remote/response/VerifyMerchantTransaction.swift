//
//  VerifyMerchantTransaction.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

internal struct VerifyMerchantTransaction : Codable {
      var status : String? = nil
      var processorCode : String? = nil
      var advice : Advice? = nil
}
