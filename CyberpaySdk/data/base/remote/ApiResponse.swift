//
//  ApiResponse.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

// Generic response payload
struct ApiResponse<T: Codable>: Codable {
    
    let data: T?
    var message: String?
    var succeeded: Bool
}
