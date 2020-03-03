//
//  ViewController.swift
//  cyberpaysdk
//
//  Created by davidehigiator on 02/23/2020.
//  Copyright (c) 2020 davidehigiator. All rights reserved.
//

import UIKit
import cyberpaysdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
           CyberpaySdk.shared.initialise(with: "7b03633edd5b40a880bbef855159d31d", mode: .Debug)
        .setTransaction(forCustomerEmail: "CUSTOMER_EMAIL", amountInKobo: 5000)
                .dropInCheckout(rootController: self, onSuccess: {result in
                    print(result.reference)
                    
                }, onError: { (result, error) in
                    print(error)
                   
                }, onValidate: {result in
                  
                })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

