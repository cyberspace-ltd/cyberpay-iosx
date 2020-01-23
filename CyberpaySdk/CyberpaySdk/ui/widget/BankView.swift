//
//  BankView.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/10/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import UIKit

internal class BankView : UIView {
    
    var bankName = UITextField()
    var accoutNumber = UITextField()
    
    @objc func dismissKeyboard() {
           endEditing(true)
       }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.accoutNumber.inputAccessoryView = keyboardToolbar
    }

    
    func setupComponents(){
        
        backgroundColor = .white
        
        // card number
        bankName.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bankName)
    
        bankName.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        bankName.heightAnchor.constraint(equalToConstant: 45).isActive = true
        bankName.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        bankName.setLeftPadding(10)
        bankName.setRightPadding(10)
        
        bankName.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        bankName.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
       
        bankName.placeholder = "Bank Name"
        
        bankName.layer.cornerRadius = 5
        bankName.backgroundColor = UIColor.init(named: "#F7F7F7")
        bankName.layer.borderColor = UIColor.init(named: "#F7F7F7")?.cgColor
        bankName.keyboardType = UIKeyboardType.phonePad
        bankName.layer.borderWidth = 0.5
        
        // card expiry
        accoutNumber.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accoutNumber)
        
        accoutNumber.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        accoutNumber.topAnchor.constraint(equalTo: bankName.bottomAnchor, constant: 20 ).isActive = true
        
        accoutNumber.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        accoutNumber.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
        accoutNumber.placeholder = "Account Number"
        accoutNumber.layer.borderColor = UIColor.init(named: "#F7F7F7")?.cgColor
        accoutNumber.layer.borderWidth = 0.5
        accoutNumber.layer.cornerRadius = 5
        accoutNumber.setRightPadding(10)
        accoutNumber.setLeftPadding(10)
        
    
        bankName.setLeftPadding(10)
        bankName.setRightPadding(10)
        
        
        setDoneOnKeyboard()
     
    }

    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setupComponents();
       // let _ = initViewComponents();
        
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupComponents();
    }
    
    
    override public init(frame: CGRect){
        super.init(frame: frame)
        setupComponents();
       // let _ = initViewComponents();
    }
    
    
}
