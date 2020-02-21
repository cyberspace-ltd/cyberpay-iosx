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


        let transaction = Transaction()
        transaction.amount = 5000
        transaction.customerEmail = "test@email.com"
        transaction.merchantReference =  UUID().uuidString

        CyberpaySdk.shared.initialise(integrationKey: "7b03633edd5b40a880bbef855159d31d", mode: Mode.Debug)

        CyberpaySdk.shared.checkoutTransaction(rootController: self, transaction: transaction,
                                                 onSuccess: {result in
            print(result.reference)

        }, onError: { (result, error) in
            print(error)

        }, onValidate: {result in

        })

    }



}



