//
//  ViewController.swift
//  Cyberpay
//
//  Created by Sunday Okpoluaefe on 1/23/20.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import UIKit
import CyberpaySdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let card = Card()
        card.cvv = "000"
        card.email = "test@email.com"

        let transaction = Transaction()
        transaction.amount = 10000
        transaction.customerEmail = "test@email.com"
        transaction.merchantReference = "heplehnjdnjnene3t" + String(Int.random(in: 100 ..< 1000))

        CyberpaySdk.INSTANCE.checkoutTransaction(rootController: self, transaction: transaction,
           onSucess: {result in
            print(result.reference)

        }, onError: { (result, error) in
            print(error)

        }, onValidate: {result in

        })

    }



}



