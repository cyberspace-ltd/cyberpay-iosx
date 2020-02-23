//
//  Locale.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

extension Locale {
    static let currency: [String: (code: String?, symbol: String?)] = Locale.isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
        $0[$1] = (locale.currencyCode, locale.currencySymbol)
    }
}

extension String{
     func toCurrencyFormat() -> String {
        if let intValue = Int(self){
           let numberFormatter = NumberFormatter()
           numberFormatter.locale = Locale(identifier: "ig_NG")/* Using Nigeria's Naira here or you can use Locale.current to get current locale, please change to your locale, link below to get all locale identifier.*/
           numberFormatter.numberStyle = NumberFormatter.Style.currency
           return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
      }
    return ""
  }
}
