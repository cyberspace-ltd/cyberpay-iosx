//
//  BankRepository.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 19/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal protocol BankRepository {
    func getBanks() -> Observable<[BankResponse]>
    func getAllBanks() -> Observable<ApiResponse<[BankResponse]>>
    func getAccountName(bankCode: String, accountNo: String) -> Observable<ApiResponse<AccountResponse>>
}
