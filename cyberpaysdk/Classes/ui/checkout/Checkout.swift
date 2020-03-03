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
        
        
        let testModelLabel = UILabel()
        testModelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        testModelLabel.text  = "This is a test page. Do not use with production cards"
        testModelLabel.textAlignment = .center
        testModelLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        testModelLabel.textColor = UIColor.white
        testModelLabel.backgroundColor = UIColor.init(hexString: "E7403D")
        testModelLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width).isActive = true
        let logoImage = UIImageView()
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage.image = UIImage(named: "cyberpay-logo", in: Bundle(for: CyberpaySdk.self), compatibleWith: nil)
        
        logoImage.contentMode = .scaleAspectFit
        
        
        let testStack   = UIStackView()
        testStack.translatesAutoresizingMaskIntoConstraints = false
        testStack.axis  = NSLayoutConstraint.Axis.vertical
        testStack.distribution  = UIStackView.Distribution.fill
        testStack.alignment = UIStackView.Alignment.center
        testStack.spacing   = 16.0
        testStack.addArrangedSubview(testModelLabel)
        
        
        if CyberpaySdk.shared.envMode == .Debug {
            
            scrollView.addSubview(testStack)
            
            scrollView.addSubview(logoImage)
            
            
            testModelLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
            testModelLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
            //Constraints
            testStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            testStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
            testStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
            testStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
            testStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
            logoImage.topAnchor.constraint(equalTo: testStack.bottomAnchor, constant: 40).isActive = true
            
        }
        else {
            scrollView.addSubview(logoImage)
            
            logoImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
            
        }
        logoImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        //payment method
        payMethod = PaymentMethod(onSelect: {
            v in
            if(v == 0){
                self.cardView.isHidden = false
                self.bankView.isHidden = true
                self.presenter.paymentOption = TransactionType.Card
                
                self.onCardPay()
                self.view.endEditing(true)
            }
            else {
                self.cardView.isHidden = true
                self.bankView.isHidden = false
                self.presenter.paymentOption = TransactionType.Bank
                self.onBankPay()
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
        
        secureImage.image = UIImage(named: "payment-logo-gray", in: Bundle(for: CyberpaySdk.self), compatibleWith: nil)
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
        bankView.bankName.setOnTextChanged(onTextChanged: bankNameChanged(text:))
        
        
        bankView.accoutNumber.isEnabled = false
        
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
    
    func bankNameChanged(text: String) {
        self.toggleVerificationView(shouldHide: true)
        self.bankView.accoutNumber.text = ""
        onDisablePay()
    }
    
    
    
    func accountNumberChanged(text: String) {
        self.toggleVerificationView(shouldHide: true)
        onDisablePay()
        if (text.count == 10){
            view.endEditing(true)
            canContinue = true
            onDisablePay()
            btContinue.setTitle("Verifying...", for: UIControl.State.normal)
            presenter.getAccountName(bankCode: bankAccount.bank!.bankCode!, account: text)
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
            
            self.card.cardType = text.suggestedCardType()
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
    
    
    func confirmRedirect(with bank: BankResponse){
        onBankRedirect!(bank)
    }
    
    
    @objc func actionView(sender: UIGestureRecognizer) -> Void {
        
        if(presenter.paymentOption == TransactionType.Card){
            
            self.card.cvv = cardView.cardCvv.text!
            self.card.number = cardView.cardNumber.text!.formattedCardNumber()
            
            let exp: [String] = cardView.cardExpiry.text?.components(separatedBy: "/") ?? [""]
            
            self.card.expiryMonth = exp[0]
            self.card.expiryYear = exp[1]
            
            if self.card.cardType == nil {
                self.card.cardType = .verve // set default
            }
            
            onCard!(self.card)
            
            
        }
        else if(presenter.paymentOption == TransactionType.Bank){
            
            switch bankAccount.bank?.processingType {
            case "External":
                self.onBankRedirect!(self.bankAccount.bank!)
                
                break
            case "Internal":
                self.onBank!(self.bankAccount)
                
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
        
        onCardPay()
        
        
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
            self.toggleVerificationView(shouldHide: true)
            
        }
    }
    
    func onBankPay() {
        onDisablePay()
        presenter.loadBanks()
        presenter.getBankTransactionAdvice(transaction: transaction)
        
    }
    
    func onCardPay() {
        onDisablePay()
        presenter.getCardTransactionAdvice(transaction: transaction)
        
    }
    
    func onLoad() {
        
        DispatchQueue.main.async {
            
            self.bankView.bankName.placeholder = "Loading..."
            self.bankView.bankName.isLoading = true
        }
    }
    
    func onLoadComplete(banks: Array<BankResponse>) {
        
        DispatchQueue.main.async {
            
            self.bankList = banks
            self.bankView.bankName.placeholder = "Select Bank"
            self.bankView.bankName.isLoading = false
            self.bankView.bankName.isEnabled = true
            
            let bankNameRecognizer = UITapGestureRecognizer()
            
            bankNameRecognizer.addTarget(self, action: #selector(self.tappedBankNameTextView(_:)))
            
            self.bankView.bankName.addGestureRecognizer(bankNameRecognizer)
            
            
            //            self.bankView.bankName.loadDropdownData(data:  self.bankList.map {$0.bankName!}, onSelect: self.bankName_onSelect)
        }
        
    }
    
    @objc func tappedBankNameTextView(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            
            let bankselectView = BankSelectView(rootController: self,banksResponse: self.bankList, onFinished: { (bank) in
                
                self.toggleVerificationView(shouldHide: true)
                self.bankView.accoutNumber.text = ""
                self.onDisablePay()
                self.bankAccount.bank = bank
                self.bankView.bankName.text = bank.bankName
                
                if bank.processingType == "External" {
                    self.confirmRedirect(with: bank)
                }
                self.bankView.accoutNumber.isEnabled = true
                
                
                
            }) {
                
                
            }
            
            self.present(bankselectView, animated: false, completion: nil)
            
            
            
        }
    }
    
    func toggleVerificationView(shouldHide: Bool)  {
        
        if shouldHide {
            UIView.animate(withDuration: 0.3, animations: {
                self.bankView.verificationImage.alpha = 0
                self.bankView.accountName.alpha = 0
                self.bankView.verificationStack.alpha = 0
            }) { (finished) in
                self.bankView.verificationImage.isHidden = shouldHide
                self.bankView.accountName.isHidden = shouldHide
                self.bankView.verificationStack.isHidden = shouldHide
            }
            
        }
        else {
            
            self.bankView.verificationImage.isHidden = shouldHide
            self.bankView.accountName.isHidden = shouldHide
            self.bankView.verificationStack.isHidden = shouldHide
            UIView.animate(withDuration: 0.3) {
                self.bankView.verificationImage.alpha = 1
                self.bankView.accountName.alpha = 1
                self.bankView.verificationStack.alpha = 1
            }
            
            
        }
        
    }
    
    func onAccountName(account: AccountResponse) {
        DispatchQueue.main.async {
            self.bankView.accoutNumber.isEnabled = true
            self.bankAccount.accountNumber =   self.bankView.accoutNumber.text
            self.bankView.accountName.text = ""
            account.accountName.split(separator: " ").map({ name in
                self.bankView.accountName.text = "\(  self.bankView.accountName.text ?? "") \(name.localizedCapitalized)"
            })
            self.toggleVerificationView(shouldHide: false)
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
