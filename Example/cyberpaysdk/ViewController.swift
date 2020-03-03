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
        
           CyberpaySdk.shared.initialise(with: "5704d9ab0e114746accc5db8e927821b", mode: .Live)
        .setTransaction(forCustomerEmail: "david3ti@gmail.com", amountInKobo: 5000)
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

