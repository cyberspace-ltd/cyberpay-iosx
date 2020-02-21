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
    internal var pin : String = ""
    public var cardType : SwiftLuhn.CardType?
    
    public var expiry : String? {
         return "\(expiryMonth ?? "")/\(expiryYear ?? "")"
    }
    
    public init() {}
    
    public var toJson : Any {
        var parameters: [String : Any]! = [String : Any]()
        do {
             parameters = [
              "Name" : "",
              "ExpiryMonth": expiryMonth!,
              "ExpiryYear" : expiryYear!,
              "CardNumber" : number!,
              "CVV" : cvv!,
              "CardPin" :  "\(pin)"
            ]
            let jsonData = try JSONSerialization.data(withJSONObject: parameters as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
              if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                 print(JSONString)
              }
            
            return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] as Any

           
            
        }catch _ {
            return parameters!
        }
    }

}
