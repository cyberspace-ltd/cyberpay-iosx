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
        transaction.amount = 10000
        transaction.customerEmail = "test@email.com"
        transaction.merchantReference =  UUID().uuidString

        CyberpaySdk.shared.initialise(integrationKey: "9eae4047769743489e27b963aeb73147", mode: Mode.Live)
        CyberpaySdk.shared.checkoutTransaction(rootController: self, transaction: transaction,
                                                 onSuccess: {result in
            print(result.reference)

        }, onError: { (result, error) in
            print(error)

        }, onValidate: {result in

        })

    }



}



