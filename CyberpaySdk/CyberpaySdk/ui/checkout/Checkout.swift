//
//  Checkout.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/5/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import MaterialComponents.MaterialBottomSheet

class Checkout : MDCBottomSheetController {
    
    var presenter: CheckoutViewPresenter!
     var btContinue = UIButton()
     var pageTitle = UILabel()
     var debugText = UILabel()
     var pageDesc = UILabel()
     var merchantLogo = UIImageView()
 
     var secureImage = UIImageView()
     var cyberpayLogo = UIImageView()
    
     var cardView = CardView()
     var bankView = BankView()
    
    var transactionType = TransactionType.Card
    
     var payMethod : PaymentMethod!
    var transaction : Transaction!
    
     var card = Card()
       
     let scrollView: UIScrollView = {
              let v = UIScrollView()
              v.translatesAutoresizingMaskIntoConstraints = false
              v.backgroundColor = .white
              return v
          }()
    
    func setupComponents() {
        
       self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
          
       self.view.addSubview(scrollView)
       self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 400)
       self.dismissOnDraggingDownSheet = false
       self.dismissOnBackgroundTap = false

       // constrain the scroll view to 8-pts on each side
       scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
       scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
       scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
       scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(pageTitle)
        pageTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        
        pageTitle.text = "Pay"
        pageTitle.font = UIFont.boldSystemFont(ofSize: 24)
        pageTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        
        //payment method
        payMethod = PaymentMethod(onSelect: {
            v in
            if(v == 0){
                self.cardView.isHidden = false
                self.bankView.isHidden = true
                self.transactionType = TransactionType.Card
            }
            else {
                self.cardView.isHidden = true
                self.bankView.isHidden = false
                self.transactionType = TransactionType.Bank
            }
        })
        
        payMethod.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(payMethod)
        
        payMethod.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 40).isActive = true
        
        payMethod.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        payMethod.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        payMethod.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        payMethod.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //card view
        cardView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cardView)
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 5
        cardView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        
        cardView.topAnchor.constraint(equalTo: payMethod.bottomAnchor, constant: 50).isActive = true
        
        cardView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10).isActive = true
        
        cardView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        
        cardView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // bank view
        
        //card view
        bankView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bankView)
        
        bankView.backgroundColor = .white
        bankView.layer.cornerRadius = 5
        bankView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        
        bankView.topAnchor.constraint(equalTo: payMethod.bottomAnchor, constant: 50).isActive = true
        
        bankView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10).isActive = true
        
        bankView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        
        bankView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        //set up pay button
        //setup button
        scrollView.addSubview(btContinue)
        btContinue.translatesAutoresizingMaskIntoConstraints = false
    
        btContinue.setTitle("Pay ₦\(transaction.amount / 100)", for: UIControl.State.normal)
        btContinue.backgroundColor = UIColor.init(hexString: Constants.primaryColor)
      
        btContinue.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        btContinue.heightAnchor.constraint(equalToConstant: 45).isActive = true
       // btContinue.widthAnchor.constraint(equalToConstant: 300).isActive = true
        btContinue.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        btContinue.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        btContinue.layer.cornerRadius = 5
        
        btContinue.topAnchor.constraint(equalTo: payMethod.bottomAnchor, constant: 200).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.actionView))
        btContinue.addGestureRecognizer(gesture);
        
        //secured
        
        secureImage.translatesAutoresizingMaskIntoConstraints = false
        secureImage.image = UIImage(named: "background")
        
    //    let image: UIImage = UIImage(named: "background")!
        //secureImage.image = UIImage(named: "background")
      //  secureImage.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 24, height: 24))
        scrollView.addSubview(secureImage)
        
        
        //secureImage.backgroundColor = .red
        
        secureImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        secureImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        secureImage.topAnchor.constraint(equalTo: btContinue.bottomAnchor, constant: 20).isActive = true
        secureImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true


        bankView.isHidden = true
       
        cardView.cardNumber.setOnTextChanged(onTextChanged: cardNumberChanged(text:))
        
        cardView.cardCvv.setOnTextChanged(onTextChanged: cardCvvChanged(text:))
        
        cardView.cardExpiry.setOnTextChanged(onTextChanged: cardExpiryChanged(text:))
        
     
        disablePay()
    }
    
    private func showProgress(message: String)
     {
         LoadingIndicatorView.show(message)
     }
     
     private func dismissProgress(){
         LoadingIndicatorView.hide()
     }
     
    
    func enablePay(){
        self.btContinue.isEnabled = true
        self.btContinue.alpha = 1.0
    }
    
    func disablePay(){
         self.btContinue.isEnabled = false
         self.btContinue.alpha = 0.4
    }
    
    func cardCvvChanged(text: String) {
        if(text.isValidCvv()){
            self.card.cvv = text
            
            print(self.card.expiry!)
            
            if(self.card.number?.isValidCardNumber() ?? false &&  self.card.expiry?.isValidExpiry() ?? false)
            {
                enablePay()
            }
        }
        
        else {
            disablePay()
        }
    }
    
    func cardExpiryChanged(text: String) {
        if(text.isValidExpiry()){
            let exp = text.components(separatedBy: "/")
            self.card.expiryYear = exp[1]
            self.card.expiryMonth = exp[0]
            
            if(self.card.number?.isValidCardNumber() ?? false &&  self.card.cvv?.isValidCvv() ?? false)
            {
                enablePay()
            }
            
    
        }
        else {
            disablePay()
        }
   }
    
    func cardNumberChanged(text: String) {
    
        if(text.isValidCardNumber()){
           
            self.card.cardType = text.cardType()
            self.card.number = text
            
            if(self.card.expiry?.isValidExpiry() ?? false &&  self.card.cvv?.isValidCvv() ?? false)
            {
                enablePay()
            }
        
        }
        else {
            disablePay()
        }
        
    
    }
    

    
    
    @objc func actionView(sender: UIGestureRecognizer) -> Void {

        if(transactionType == TransactionType.Card){
            print("hello ...")
            self.card.cvv = cardView.cardCvv.text!
            self.card.number = cardView.cardNumber.text!.formattedCardNumber()
            
            let exp: [String] = cardView.cardExpiry.text?.components(separatedBy: "/") ?? [""]
            
            self.card.expiryMonth = exp[0]
            self.card.expiryYear = exp[1]
            
            onCard!(self.card)
        
        }
    }
    
    private var onCard : ((Card) -> Void)?
    private var onBank : ((Bank) -> Void)?
    private var onBankRedirect : ((Bank) -> Void)?
    
    init(transaction: Transaction,rootController: UIViewController, onCardSubmit: @escaping (_ card: Card)->(), onBankSubmit: @escaping (_ card: Bank)->(), onRedirect: @escaping (_ bank: Bank)->()) {
        
        self.transaction = transaction
        
        onCard = onCardSubmit
        onBank = onBankSubmit
        onBankRedirect = onRedirect
        
        super.init(contentViewController: rootController)
    
        
    }
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
       }
       
   override func viewDidLoad() {
           setupComponents()
       }
    
    
    
}

extension Checkout: CheckoutView {
    func onError(message: String) {
        fatalError("Not Implemented")
    }
    
    func onBankPay() {
                fatalError("Not Implemented")

    }
    
    func onCardPay() {
                fatalError("Not Implemented")

    }
    
    func onLoad() {
                fatalError("Not Implemented")

    }
    
    func onLoadComplete(banks: Array<BankResponse>) {
                fatalError("Not Implemented")

    }
    
    func onAccountName(account: AccountResponse) {
                fatalError("Not Implemented")

    }
    
    func onUpdateAdvice(advice: Advice) {
                fatalError("Not Implemented")

    }
    
    func onCancelTransaction(transaction: Transaction) {
                fatalError("Not Implemented")

    }
    
    func onCancelTransactionError(transaction: Transaction) {
                fatalError("Not Implemented")

    }
    
    func onDisablePay() {
                fatalError("Not Implemented")

    }
    
    func onEnablePay() {
                fatalError("Not Implemented")

    }
    
    
}
