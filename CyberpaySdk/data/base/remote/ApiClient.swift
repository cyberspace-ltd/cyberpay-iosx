//
//  ApiClient.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 11/28/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ApiClient {
    
    private let urlDebug = URL(string: "https://payment-api.staging.cyberpay.ng/api/v1/")!
    private let urlLive = URL(string: "https://payment-api.cyberpay.ng/api/v1/")!

    func send<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: self.urlDebug)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
