//
//  TransactionRepository.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/2/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TransactionRepository {
    
    let service = TransactionService()
    
    func beginTransaction(transaction : Transaction) -> Observable<ApiResponse<SetTransaction>> {
        let request = ApiRequest()
        request.parameters["currency"] = transaction.currency
        request.parameters["merchantRef"] = transaction.merchantReference
        request.parameters["amount"] = String(format:"%f", transaction.amount)
        request.parameters["description"] = transaction.description
        request.parameters["integrationKey"] = transaction.key
        request.parameters["returnUrl"] = transaction.returnUrl
        request.parameters["customerEmail"] = transaction.customerEmail
        request.parameters["clientType"] = transaction.clientType
        /*
         param["splits"] = transaction.splits
         */
        return service.begingTransaction(request: request)
    }
    
    
    
}
