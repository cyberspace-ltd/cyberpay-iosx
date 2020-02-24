//
//  Advice.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

internal struct Advice : Codable {
    var businessName: String? = nil
    var amount: Double? = 0.0
    var charge: Double? = 0.0
    var customerName: String? = ""
    var customerId: String? = ""
    var status: String? = ""
    public var amountToPay : String {
          let currencyFormatter = NumberFormatter()
          currencyFormatter.usesGroupingSeparator = true
          currencyFormatter.numberStyle = .currency
          // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "ig_NG")
        let priceString = currencyFormatter.string(from: NSNumber(value: (amount! + charge!)/100))!
        
        return priceString
      }
}
