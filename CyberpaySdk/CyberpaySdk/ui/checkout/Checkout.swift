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
    
    
    fileprivate lazy var presenter: CheckoutPresenter = {
        return CheckoutPresenter(view: self)
    }()
    var btContinue = UIButton()
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
    
    private var bankList: [BankResponse] = []
    
    private var canContinue = false
    
    var card = Card()
    
    private var bankAccount = BankAccount()
    
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    func setupComponents() {
        
        //        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(scrollView)
        self.dismissOnDraggingDownSheet = false
        self.dismissOnBackgroundTap = false
        
        // constrain the scroll view to 8-pts on each side
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 220).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let logoImage = UIImageView()
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(named: "cyberpay-logo")
        logoImage.contentMode = .scaleAspectFit
        
        scrollView.addSubview(logoImage)
        
        logoImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        logoImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        //payment method
        payMethod = PaymentMethod(onSelect: {
            v in
            if(v == 0){
                self.cardView.isHidden = false
                self.bankView.isHidden = true
                self.transactionType = TransactionType.Card
                self.presenter.cardPay()
                self.view.endEditing(true)
            }
            else {
                self.cardView.isHidden = true
                self.bankView.isHidden = false
                self.transactionType = TransactionType.Bank
                self.presenter.bankPay()
                self.view.endEditing(true)

            }
        })
        
        payMethod.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(payMethod)
        
        payMethod.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 40).isActive = true
        
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
        btContinue.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        btContinue.setTitle("Pay ₦\(transaction.amount / 100)", for: UIControl.State.normal)
        btContinue.backgroundColor = UIColor.init(hexString: Constants.primaryColor)
        
        btContinue.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        btContinue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        // btContinue.widthAnchor.constraint(equalToConstant: 300).isActive = true
        btContinue.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        btContinue.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        btContinue.layer.cornerRadius = 5
        
        btContinue.topAnchor.constraint(equalTo: payMethod.bottomAnchor, constant: 210).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.actionView))
        btContinue.addGestureRecognizer(gesture);
        
        //secured
        
        secureImage.translatesAutoresizingMaskIntoConstraints = false
        
        secureImage.image = UIImage(named: "payment-logo-gray")
        //        secureImage.image = UIImage(named: "secured-logo")
        secureImage.contentMode = .scaleAspectFit
        
        scrollView.addSubview(secureImage)
        
        
        secureImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        secureImage.topAnchor.constraint(equalTo: btContinue.bottomAnchor, constant: 20).isActive = true
        secureImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        
        bankView.isHidden = true
        
        cardView.cardNumber.setOnTextChanged(onTextChanged: cardNumberChanged(text:))
        
        cardView.cardCvv.setOnTextChanged(onTextChanged: cardCvvChanged(text:))
        
        cardView.cardExpiry.setOnTextChanged(onTextChanged: cardExpiryChanged(text:))
        
        bankView.accoutNumber.setOnTextChanged(onTextChanged: accountNumberChanged(text:))

        bankView.accoutNumber.isEnabled = false
        bankView.bankName.setOnTextChanged(onTextChanged: bankName_onSelect(selectedText: ))

        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: (self.contentViewController.view.frame.size.height))
        
        
        onDisablePay()
    }
    
    private func showProgress(message: String)
    {
        LoadingIndicatorView.show(message)
    }
    
    private func dismissProgress(){
        LoadingIndicatorView.hide()
    }
    
    
  
    
    func accountNumberChanged(text: String) {
        if (text.count == 10){
            view.endEditing(true)
            canContinue = true
            bankView.verificationStack.alpha = 1
            onDisablePay()
            btContinue.setTitle("Verifying...)", for: UIControl.State.normal)
            presenter.getAccountName(bankCode: bankAccount.bank!.bankCode!, account: text)
        }
    }
    
  
    
    func bankName_onSelect(selectedText: String) {
        // check bank processing type,
        if let selectedBank = bankList.first(where: { $0.bankName == selectedText }) {
            print("The Bank Chosen is \(selectedBank).")
        }
     }
    
    func cardCvvChanged(text: String) {
        if(text.isValidCvv()){
            self.card.cvv = text
            
            print(self.card.expiry!)
            
            if(self.card.number?.isValidCardNumber() ?? false &&  self.card.expiry?.isValidExpiry() ?? false)
            {
                onEnablePay()
            }
        }
            
        else {
            onDisablePay()
        }
    }
    
    func cardExpiryChanged(text: String) {
        if(text.isValidExpiry()){
            let exp = text.components(separatedBy: "/")
            self.card.expiryYear = exp[1]
            self.card.expiryMonth = exp[0]
            
            if(self.card.number?.isValidCardNumber() ?? false &&  self.card.cvv?.isValidCvv() ?? false)
            {
                onEnablePay()
            }
            
            
        }
        else {
            onDisablePay()
        }
    }
    
    func cardNumberChanged(text: String) {
        
        if(text.isValidCardNumber()){
            
            self.card.cardType = text.cardType()
            self.card.number = text
            
            if(self.card.expiry?.isValidExpiry() ?? false &&  self.card.cvv?.isValidCvv() ?? false)
            {
                onEnablePay()
            }
            
        }
        else {
            onDisablePay()
        }
        
        
    }
    
    
    @objc func actionView(sender: UIGestureRecognizer) -> Void {
        
        if(presenter.paymentOption == TransactionType.Card){
            
            self.card.cvv = cardView.cardCvv.text!
            self.card.number = cardView.cardNumber.text!.formattedCardNumber()
            
            let exp: [String] = cardView.cardExpiry.text?.components(separatedBy: "/") ?? [""]
            
            self.card.expiryMonth = exp[0]
            self.card.expiryYear = exp[1]
            
            onCard!(self.card)
            
        }
        else if(presenter.paymentOption == TransactionType.Bank){
            
            switch bankAccount.bank?.processingType {
            case "External":
                onBankRedirect!(self.bankAccount.bank!)
                break
            case "Internal":
                onBank!(self.bankAccount)
                break
            default:
                break
            }
            
        }
    }
    
    private var onCard : ((Card) -> Void)?
    private var onBank : ((BankAccount) -> Void)?
    private var onBankRedirect : ((BankResponse) -> Void)?
    
    init(transaction: Transaction,rootController: UIViewController, onCardSubmit: @escaping (_ card: Card)->(), onBankSubmit: @escaping (_ card: BankAccount)->(), onRedirect: @escaping (_ bank: BankResponse)->()) {
        
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
        presenter.viewDidLoad()
        setupComponents()
    }
    
    
    
}

extension Checkout: CheckoutView {
    
    func onError(message: String) {
        
           DispatchQueue.main.async {
            self.bankView.accoutNumber.isEnabled = true
            self.bankView.accountName.text = ""
            self.btContinue.setTitle("Pay \(self.transaction.amountToPay)", for: UIControl.State.normal)
            self.bankView.verificationStack.alpha = 0
            
        }
    }
    
    func onBankPay() {
        presenter.loadBanks()
        presenter.getBankTransactionAdvice(transaction: transaction)
        onDisablePay()
        
    }
    
    func onCardPay() {
        presenter.getCardTransactionAdvice(transaction: transaction)
        onDisablePay()
        
    }
    
    func onLoad() {
        
        DispatchQueue.main.async {
        
            self.bankView.bankName.placeholder = "Loading..."
        }
    }
    
    func onLoadComplete(banks: Array<BankResponse>) {
        
           DispatchQueue.main.async {
            
            self.bankList = banks
            self.bankView.bankName.placeholder = "Select Bank"
            self.bankView.accoutNumber.isEnabled = true
            self.bankView.bankName.loadDropdownData(data:  self.bankList.map {$0.bankName!}, onSelect: self.bankName_onSelect)
        }
        
    }
    
    func onAccountName(account: AccountResponse) {
         DispatchQueue.main.async {
            self.bankView.accoutNumber.isEnabled = true
          self.bankAccount.accountNumber =   self.bankView.accoutNumber.text
        
         account.accountName.split(separator: " ").map({ name in
            self.bankView.accountName.text = "\(  self.bankView.accountName.text ?? "") \(name.localizedCapitalized)"
        })
          self.bankView.verificationStack.alpha = 1
          self.btContinue.setTitle("Pay \(  self.transaction.amountToPay)", for: UIControl.State.normal)
        }
              self.onEnablePay()
        
    }
    
    func onUpdateAdvice(advice: Advice) {
         DispatchQueue.main.async {
          self.btContinue.setTitle("Pay \(advice.amountToPay)", for: UIControl.State.normal)
          self.transaction.amount = advice.amount!
          self.transaction.charge = advice.charge!
         self.onEnablePay()
        }
        
    }
    
    func onCancelTransaction(transaction: Transaction) {
        DispatchQueue.main.async {
            self.dismissProgress()
            self.dismiss(animated: true, completion: nil)
        }
      
        //              listener.onCancel(transaction)
    }
    
    func onCancelTransactionError(transaction: Transaction) {
        DispatchQueue.main.async {
            self.dismissProgress()

              }
    }
    
    func onDisablePay() {
          DispatchQueue.main.async {
            self.btContinue.isEnabled =  false
            self.btContinue.alpha = 0.3
        }
     
    }
    
    func onEnablePay() {
        DispatchQueue.main.async {
            self.btContinue.isEnabled =  true
            self.btContinue.alpha = 1
            }
    
    }
    
    
}
