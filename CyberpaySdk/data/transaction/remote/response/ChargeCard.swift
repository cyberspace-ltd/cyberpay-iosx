//
//  ChargeCard.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

internal struct ChargeCard : Decodable {
    
       var reference: String?
       var status: String?
       var redirectUrl: String?
       var message: String?
       var reason: String?
       var responseAction: String?
    
}
