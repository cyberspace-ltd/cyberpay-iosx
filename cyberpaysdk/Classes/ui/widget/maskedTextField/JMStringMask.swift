//
//  JMMaskedString.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 1/13/20.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation


public struct JMStringMask: Equatable {
    
    var mask: String = ""
    
    let letterMaskCharacter: Character = "A"
    let numberMaskCharacter: Character = "0"
    let alphanumericMaskCharacter: Character = "*"
    
    private init() { }
    
    public init(mask: String) {
        self.init()
        
        self.mask = mask
    }
    
    public static func ==(lhs: JMStringMask, rhs: JMStringMask) -> Bool {
        return lhs.mask == rhs.mask
    }
    
    public func mask(string: String?) -> String? {
        
        guard let string = string else { return nil }

        if string.count > self.mask.count {
            return nil
        }
        
        var formattedString = ""
        
        var currentMaskIndex = 0
        for i in 0..<string.count {
            if currentMaskIndex >= self.mask.count {
                return nil
            }
            
            let currentCharacter = string[string.index(string.startIndex, offsetBy: i)]
            var maskCharacter = self.mask[self.mask.index(string.startIndex, offsetBy: currentMaskIndex)]
            
            if currentCharacter == maskCharacter {
                formattedString.append(currentCharacter)
            } else {
                while (maskCharacter != letterMaskCharacter
                    && maskCharacter != numberMaskCharacter
                    && maskCharacter != alphanumericMaskCharacter) {
                    formattedString.append(maskCharacter)
                    
                    currentMaskIndex += 1
                    maskCharacter = self.mask[self.mask.index(string.startIndex, offsetBy: currentMaskIndex)]
                }
                
                if maskCharacter != alphanumericMaskCharacter {
                    let isValidLetter = maskCharacter == letterMaskCharacter && self.isValidLetterCharacter(currentCharacter)
                    let isValidNumber = maskCharacter == numberMaskCharacter && self.isValidNumberCharacter(currentCharacter)
                    
                    if !isValidLetter && !isValidNumber {
                        return nil
                    }
                }
                
                formattedString.append(currentCharacter)
            }
            
            currentMaskIndex += 1
        }
        
        return formattedString
    }
    
    public func unmask(string: String?) -> String? {
        
        guard let string = string else { return nil }
        var unmaskedValue = ""
        
        for character in string {
            if self.isValidLetterCharacter(character) || self.isValidNumberCharacter(character) {
                unmaskedValue.append(character)
            }
        }
        
        return unmaskedValue
    }
    
    private func isValidLetterCharacter(_ character: Character) -> Bool {

        let string = String(character)
        if string.unicodeScalars.count > 1 {
            return false
        }
        
        let lettersSet = NSCharacterSet.letters
        let unicodeScalars = string.unicodeScalars
        return lettersSet.contains(unicodeScalars[unicodeScalars.startIndex])
    }
    
    private func isValidNumberCharacter(_ character: Character) -> Bool {
        
        let string = String(character)
        if string.unicodeScalars.count > 1 {
            return false
        }
        
        let lettersSet = NSCharacterSet.decimalDigits
        let unicodeScalars = string.unicodeScalars
        return lettersSet.contains(unicodeScalars[unicodeScalars.startIndex])
    }
    
}
