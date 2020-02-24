//
//  String+SwiftLuhn.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 1/13/20.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

public extension String {
    
    func isValidCardNumber() -> Bool {
        do {
            try SwiftLuhn.performLuhnAlgorithm(with: self)
            return true
        }
        catch {
            return false
        }
    }
    
    func isValidCvv() -> Bool{
        
        if(self.lengthOfBytes(using: String.defaultCStringEncoding) != 3){
            return false
        }
        else {
            return true
        }
    }
    
    func isValidExpiry() -> Bool {
        
        let date = Date()
         let calendar = Calendar.current
         let components = calendar.dateComponents([.year, .month, .day], from: date)
         
         let exp = self.components(separatedBy: "/")
         let yr = Int(String(components.year!).suffix(2)) ?? 0
         
        if( exp.count > 1){
            
        if(yr > Int(exp[1]) ?? 0 ) {
             return false
         }
         
         else if((components.month! >  Int(exp[0]) ?? 0) && (yr >= Int(exp[1]) ?? 0)){
             
              return false
         }
         
         
         if(Int(exp[0]) ?? 0 > 12 || Int(exp[0]) ?? 0 < 1 )
         {
             return false
         }
         
        return true
        }
        else {
            return false
        }
        
    }
    
    func cardType() -> SwiftLuhn.CardType? {
        let cardType = try? SwiftLuhn.cardType(for: self)
        return cardType
    }
    func suggestedCardType() -> SwiftLuhn.CardType? {
        let cardType = try? SwiftLuhn.cardType(for: self, suggest: true)
        return cardType
    }
    
    func formattedCardNumber() -> String {
        let numbersOnlyEquivalent = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        return numbersOnlyEquivalent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
