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
    var accountName = UILabel()
    
    let verificationStack = UIStackView()
    
    let verificationImage = UIImageView()
    
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
        bankName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bankName.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        bankName.setLeftPadding(10)
        bankName.setRightPadding(10)
        
        bankName.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        bankName.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        
        bankName.placeholder = "Bank Name"
        
        bankName.keyboardType = UIKeyboardType.phonePad
        bankName.setCorner(radius: 4)
        if #available(iOS 13.0, *) {
            bankName.setBorder(width: 2, color: UIColor.systemGray6)
            bankName.backgroundColor = UIColor.systemGray6
            
        } else {
            // Fallback on earlier versions
            bankName.setBorder(width: 2, color: UIColor.init(named: Constants.lightGreyColor) ?? UIColor.lightGray)
            bankName.backgroundColor =  UIColor.init(named: Constants.lightGreyColor)
            
        }
        
        // card expiry
        accoutNumber.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accoutNumber)
        
        accoutNumber.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        accoutNumber.topAnchor.constraint(equalTo: bankName.bottomAnchor, constant: 20 ).isActive = true
        
        accoutNumber.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        accoutNumber.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        accoutNumber.placeholder = "Account Number"
        accoutNumber.setRightPadding(10)
        accoutNumber.setLeftPadding(10)
        accoutNumber.setCorner(radius: 4)
        if #available(iOS 13.0, *) {
            accoutNumber.setBorder(width: 2, color: UIColor.systemGray6)
            accoutNumber.backgroundColor = UIColor.systemGray6
            
        } else {
            // Fallback on earlier versions
            accoutNumber.setBorder(width: 2, color: UIColor.init(named: Constants.lightGreyColor) ?? UIColor.lightGray)
            accoutNumber.backgroundColor =  UIColor.init(named: Constants.lightGreyColor)
            
        }
        
        
        bankName.setLeftPadding(10)
        bankName.setRightPadding(10)
        
        accountName.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        accountName.textAlignment = .right
        accountName.text  = "David Ehigiator"
        accountName.backgroundColor  = UIColor.clear
        accountName.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
              
        
        verificationStack.axis  = NSLayoutConstraint.Axis.horizontal
        verificationStack.distribution  = UIStackView.Distribution.fill
        verificationStack.alignment = UIStackView.Alignment.center
        verificationStack.spacing   = 4.0
        
        if #available(iOS 13.0, *) {
            let smallConfigurationVerification = UIImage.SymbolConfiguration(scale: .small)
            
            let smallVerificationIcon = UIImage(systemName: "checkmark.seal.fill", withConfiguration: smallConfigurationVerification)
            
            verificationImage.image = smallVerificationIcon
            
        } else {
            // Fallback on earlier versions
        }
        
        
      
        
        verificationStack.addArrangedSubview(accountName)
        verificationStack.addArrangedSubview(verificationImage)
        verificationStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verificationStack)
        
        verificationStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        verificationStack.topAnchor.constraint(equalTo: accoutNumber.bottomAnchor, constant: 4).isActive = true
        
        verificationStack.heightAnchor.constraint(equalToConstant: 40).isActive = true

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
