//
//  Exception.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/5/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

public enum Exception : Error {
    case SDKNotInitializedException(message: String)
    case InvalidIntegrationException(message: String)
    case CyberpayException(message: String)
    case CardNotSetException(message: String)
    
    var localizedDescription: String? {
        switch self {
        case let .SDKNotInitializedException(message),
             let .InvalidIntegrationException(message),
             let .CardNotSetException(message),
             let .CyberpayException(message):
        
            return message
        
        }
    }
}
