//
//  CardView.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/10/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import UIKit

internal class CardView : UIView {
    
    var cardNumber = JMMaskTextField()
    var cardExpiry = JMMaskTextField()
    var cardCvv = JMMaskTextField()
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    func getKeyboardToolBar() -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        return keyboardToolbar
    }
    
    
    func setupComponents(){
        
        backgroundColor = .white
        
        // card number
        cardNumber.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardNumber)
        
        cardNumber.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cardNumber.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cardNumber.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        cardNumber.setLeftPadding(10)
        cardNumber.setRightPadding(10)
        
        cardNumber.setCorner(radius: 4)
        if #available(iOS 13.0, *) {
            cardNumber.setBorder(width: 2, color: UIColor.systemGray6)
            cardNumber.backgroundColor = UIColor.systemGray6
            
        } else {
            // Fallback on earlier versions
            cardNumber.setBorder(width: 2, color: UIColor.init(named: Constants.lightGreyColor) ?? UIColor.lightGray)
            cardNumber.backgroundColor =  UIColor.init(named: Constants.lightGreyColor)
        }
        cardNumber.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        cardNumber.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        cardNumber.placeholder = "Card Number"
        cardNumber.keyboardType = UIKeyboardType.phonePad
        
        // card expiry
        cardExpiry.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardExpiry)
        
        cardExpiry.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        cardExpiry.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: 20 ).isActive = true
        
        cardExpiry.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        cardExpiry.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        cardExpiry.placeholder = "MM/YY"
        cardExpiry.layer.borderWidth = 0.5
        cardExpiry.setRightPadding(10)
        cardExpiry.setLeftPadding(10)
        cardExpiry.setCorner(radius: 4)
        if #available(iOS 13.0, *) {
            cardExpiry.setBorder(width: 2, color: UIColor.systemGray6)
            cardExpiry.backgroundColor = UIColor.systemGray6
            
        } else {
            // Fallback on earlier versions
            cardExpiry.setBorder(width: 2, color: UIColor.init(named: Constants.lightGreyColor) ?? UIColor.lightGray)
            cardExpiry.backgroundColor =  UIColor.init(named: Constants.lightGreyColor)
            
        }
        
        
        cardExpiry.keyboardType = UIKeyboardType.phonePad
        
        
        cardCvv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardCvv)
        
        cardCvv.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        cardCvv.rightAnchor.constraint(equalToSystemSpacingAfter: rightAnchor, multiplier: -2).isActive = true
     
        cardCvv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cardCvv.setRightPadding(10)
        cardCvv.setLeftPadding(10)
        cardCvv.setCorner(radius: 4)
            if #available(iOS 13.0, *) {
                cardCvv.setBorder(width: 2, color: UIColor.systemGray6)
                cardCvv.backgroundColor = UIColor.systemGray6
                
            } else {
                // Fallback on earlier versions
                cardCvv.setBorder(width: 2, color: UIColor.init(named: Constants.lightGreyColor) ?? UIColor.lightGray)
                cardCvv.backgroundColor =  UIColor.init(named: Constants.lightGreyColor)
                
            }
            
        cardCvv.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        cardCvv.leftAnchor.constraint(equalToSystemSpacingAfter: cardExpiry.rightAnchor, multiplier: 10).isActive = true
        
        cardCvv.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: 20 ).isActive = true
        
        cardCvv.placeholder = "CVV"
        cardCvv.keyboardType = UIKeyboardType.phonePad
        
        
        cardExpiry.rightAnchor.constraint(equalTo: cardCvv.leftAnchor, constant: -10).isActive = true
        
        cardCvv.leftAnchor.constraint(equalTo: cardExpiry.rightAnchor, constant: 10).isActive = true
        
        cardCvv.widthAnchor.constraint(equalTo: cardExpiry.widthAnchor).isActive = true
        
        cardExpiry.widthAnchor.constraint(equalTo: cardCvv.widthAnchor).isActive = true
        
        //setDoneOnKeyboard()
        self.cardCvv.inputAccessoryView = getKeyboardToolBar()
        self.cardExpiry.inputAccessoryView = getKeyboardToolBar()
        self.cardNumber.inputAccessoryView = getKeyboardToolBar()
        
        cardNumber.maskString = "0000 0000 0000 0000 000"
        cardCvv.maskString = "000"
        cardExpiry.maskString = "00/00"
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
