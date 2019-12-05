//
//  ApiRequest.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/2/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation

class ApiRequest {
    var method: RequestType = RequestType.POST
    var path: String!
    var parameters: [String : String]!
    
    
    
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        if(parameters != nil && method != RequestType.GET) {
            components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
            }
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}


