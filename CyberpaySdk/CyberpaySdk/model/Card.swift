//
//  Card.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/27/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

public class Card{
    public var number : String?
    public var name : String?
    
    public var email : String?
    public var address : String?
    var last4Digits : String?
    public var phoneNumber : String?
    public var cvv : String?
    public var expiryMonth : String?
    public var expiryYear : String?
    internal var pin : String?
    public var cardType : SwiftLuhn.CardType?
    
    public var expiry : String? {
         return "\(expiryMonth ?? "")/\(expiryYear ?? "")"
    }
    
    public init() {}
    
    public var toJson : Any {
    
        var parameters: [String : Any]! = [String : Any]()
        
        do{
            parameters = [
              "Name" : "",
              "ExpiryMonth": expiryMonth!,
              "ExpiryYear" : expiryYear!,
              "CardNumber" : number!,
              "CVV" : cvv!,
              "CardPin" : pin!
            ]
                
            return try JSONSerialization.data(withJSONObject: parameters!, options: [])
            
        }catch _ {
            return parameters!
        }
    }

}
