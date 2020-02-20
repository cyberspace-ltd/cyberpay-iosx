//
//  PaymentMethod.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 1/9/20.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import UIKit

class  PaymentMethod: UIView {

    var card = UILabel()
    var bank = UILabel()
    
    var cardLine = UIView()
    var bankLine = UIView()
    
    var stackView = UIStackView()
    
    private var onSelect : ((Int) -> Void)?
    
    
    func setupComponents(){
        
        card.translatesAutoresizingMaskIntoConstraints = false
        addSubview(card)
        
        card.text = "Card"
        card.textColor = UIColor.init(hexString: Constants.primaryColor)
        card.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
       
        card.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        bank.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bank)
        bank.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        bank.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true

        bank.text = "Bank"
        bank.textColor = .gray
        bank.leftAnchor.constraint(equalTo: card.rightAnchor, constant: 10).isActive = true
        
        card.rightAnchor.constraint(equalTo: bank.leftAnchor, constant: -10).isActive = true
        
        card.textAlignment = .center
        bank.textAlignment = .center
        card.widthAnchor.constraint(equalTo: bank.widthAnchor).isActive = true
        bank.widthAnchor.constraint(equalTo: card.widthAnchor).isActive = true
        
       addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true

        stackView.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 10).isActive = true
        
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        stackView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        //add card line
        cardLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        cardLine.backgroundColor = UIColor.init(hexString: Constants.primaryColor)
        
        stackView.addArrangedSubview(cardLine)
        cardLine.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(bankLine)
        bankLine.translatesAutoresizingMaskIntoConstraints = false
    
        bankLine.backgroundColor = UIColor.init(hexString: Constants.lightGreyColor)
        bankLine.heightAnchor.constraint(equalToConstant: 2).isActive = true

        let cardGesture = UITapGestureRecognizer(target: self, action:  #selector(self.cardView))
        
        let bankGesture = UITapGestureRecognizer(target: self, action:  #selector(self.bankView))
        
        card.isUserInteractionEnabled = true
        bank.isUserInteractionEnabled = true
        
        card.addGestureRecognizer(cardGesture)
        bank.addGestureRecognizer(bankGesture)
        
    
    }
    
    @objc func bankView(sender: UIGestureRecognizer) -> Void {
            
        cardLine.backgroundColor = UIColor.init(hexString: Constants.lightGreyColor)
        bankLine.backgroundColor = UIColor.init(hexString: Constants.primaryColor)
          onSelect!(1)
        bank.textColor =  UIColor.init(hexString: Constants.primaryColor)
        card.textColor =  .gray

    }
    
    @objc func cardView(sender: UIGestureRecognizer) -> Void {
        
        bankLine.backgroundColor = UIColor.init(hexString: Constants.lightGreyColor)
        cardLine.backgroundColor = UIColor.init(hexString: Constants.primaryColor)
        onSelect!(0)
        bank.textColor =  .gray
        card.textColor =  UIColor.init(hexString: Constants.primaryColor)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setupComponents()
      
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupComponents()
    }
    
    convenience init(onSelect: @escaping (Int)->()){
        self.init()
        self.onSelect = onSelect
    }
    
    
    override public init(frame: CGRect){
        super.init(frame: frame)
        setupComponents()
    
    }
}

