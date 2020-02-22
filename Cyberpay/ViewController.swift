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
        
        
        CyberpaySdk.shared.initialise(with: "CYBERPAY_INTEGRATION_KEY", mode: .Debug)
            .setTransaction(forCustomerEmail: "CUSTOMER_EMAIL", amountInKobo: 5000)
            .dropInCheckout(rootController: self, onSuccess: {result in
                print(result.reference)
                
            }, onError: { (result, error) in
                print(error)
                
            }, onValidate: {result in
                
            })
        
    }
    
    
    
}



