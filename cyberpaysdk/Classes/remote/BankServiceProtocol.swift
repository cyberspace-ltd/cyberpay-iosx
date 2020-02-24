//
//  BankServiceProtocol.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 18/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


internal protocol BankServiceProtocol {

       func banks(request : ApiRequest) -> Observable<ApiResponse<[BankResponse]>>

       func getAllBanks(request : ApiRequest) -> Observable<ApiResponse<[BankResponse]>>

       func getAccountName(apiKey: String, request : ApiRequest) -> Observable<ApiResponse<AccountResponse>>

}
