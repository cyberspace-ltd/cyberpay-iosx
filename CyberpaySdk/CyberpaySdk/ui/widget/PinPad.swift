//
//  PinPad.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 12/10/19.
//  Copyright © 2019 cyberspace. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MaterialComponents.MaterialBottomSheet


internal class PinPad : MDCBottomSheetController, UITextFieldDelegate {
    
    
    var btContinue = UIButton()
    var pinInput = UITextField()
    var pageTitle = UILabel()
    var pageDesc = UILabel()
    var secureImage = UIImageView()
    var cyberpayLogo = UIImageView()
    var secureText = UILabel()
    
    let scrollView: UIScrollView = {
           let v = UIScrollView()
           v.translatesAutoresizingMaskIntoConstraints = false
           v.backgroundColor = .white
           return v
       }()
    
    var MAX_TEXT_LENGTH = 4
    
    func setInutLength (length : Int){
        MAX_TEXT_LENGTH = length
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.pinInput.inputAccessoryView = keyboardToolbar
    }
    
    func setupComponents() {
        
        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
         self.view.addSubview(scrollView)
         self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 400)
        self.dismissOnDraggingDownSheet = false
        self.dismissOnBackgroundTap = false

         // constrain the scroll view to 8-pts on each side
         scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
         scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0).isActive = true
         scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
         scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true

      
        // setup page title
        scrollView.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        
        pageTitle.textColor = UIColor.black
        pageTitle.font = UIFont.boldSystemFont(ofSize: 28.0)
        
        // constraints
        pageTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        pageTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        
        
        scrollView.addSubview(pageDesc)
        pageDesc.translatesAutoresizingMaskIntoConstraints = false
        
        // setup constraints
        pageDesc.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        pageDesc.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 20).isActive = true
        pageDesc.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pageDesc.numberOfLines = 0
        pageDesc.textAlignment = NSTextAlignment.center
     
        
        //
        scrollView.addSubview(pinInput)
        pinInput.translatesAutoresizingMaskIntoConstraints = false
        
        pinInput.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pinInput.topAnchor.constraint(equalTo: pageDesc.bottomAnchor, constant: 30).isActive = true
        pinInput.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pinInput.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        pinInput.delegate = self
        
        pinInput.clipsToBounds = true
        pinInput.textAlignment = NSTextAlignment.center
       
       pinInput.setCorner(radius: 4)
           if #available(iOS 13.0, *) {
               pinInput.setBorder(width: 2, color: UIColor.systemGray6)
               pinInput.backgroundColor = UIColor.systemGray6
               
           } else {
               // Fallback on earlier versions
               pinInput.setBorder(width: 2, color: UIColor.init(named: Constants.lightGreyColor) ?? UIColor.lightGray)
               pinInput.backgroundColor =  UIColor.init(named: Constants.lightGreyColor)
           }
        pinInput.keyboardType = UIKeyboardType.phonePad
        
        
        setDoneOnKeyboard()
        
        //setup secured
            scrollView.addSubview(secureText)
            secureText.translatesAutoresizingMaskIntoConstraints = false
            secureText.textColor = UIColor.black
            secureText.text = "Secured by"
            
            secureText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            secureText.topAnchor.constraint(equalTo: pinInput.bottomAnchor, constant: 50).isActive = true
        
        //setup button
          scrollView.addSubview(btContinue)
          btContinue.translatesAutoresizingMaskIntoConstraints = false
      
          view.backgroundColor = UIColor.white
          btContinue.setTitle("Continue", for: UIControl.State.normal)
          btContinue.backgroundColor = UIColor.init(hexString: Constants.primaryColor)
        
         btContinue.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 0).isActive = true
          
          btContinue.heightAnchor.constraint(equalToConstant: 40).isActive = true
          btContinue.widthAnchor.constraint(equalToConstant: 300).isActive = true
          btContinue.layer.cornerRadius = 5
          
          btContinue.topAnchor.constraint(equalTo: secureText.bottomAnchor, constant: 50).isActive = true
         btContinue.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.actionView))
        btContinue.addGestureRecognizer(gesture);
        
         
        //secureImage.image = UIImage(named: "secured")
        secureImage.frame = CGRect(x: 0, y: 0,width: 24, height: 24)
        view.addSubview(secureImage)
        secureImage.translatesAutoresizingMaskIntoConstraints = false
        
        //secureImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        secureImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        secureImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        secureImage.rightAnchor.constraint(equalTo: secureText.leftAnchor, constant: -20).isActive = true
        
        secureImage.bottomAnchor.constraint(equalTo: btContinue.topAnchor, constant: -20).isActive = true
 
       
    }

    
    private var uiController : UIViewController?
    private var onSubmitted : ((String) -> Void)?
    
    
     /* close view */
      @objc func actionView(sender: UIGestureRecognizer) -> Void {
       
        self.onSubmitted!(pinInput.text!)
        self.dismiss(animated: true, completion: nil)
       }
    

   init(contentViewController: UIViewController, inputType: InputType, onSubmit: @escaping (String)->()) {
    super.init(contentViewController: contentViewController)

        onSubmitted = onSubmit
        uiController = contentViewController
        
        switch inputType {
        case .Pin:
            pageTitle.text = "Card Pin"
            pageDesc.text = "To ensure you own this card, kindly enter your pin to continue"
            pinInput.placeholder = "Card Pin"
            pinInput.isSecureTextEntry = true
            
        case .Otp:
            pageTitle.text = "Enter Otp"
            pageDesc.text = "Kindly enter the one time password sent to your phone number or email address to complete transaction"
            pinInput.placeholder = "Otp"
            pinInput.isSecureTextEntry = true

        case .BankOtp:
            pageTitle.text = "Enter Otp"
            pageDesc.text = "You have not registered for OTP. Kindly enter the one time password sent to your phone number or email address to register"
            pinInput.isSecureTextEntry = true
            pinInput.placeholder = "Otp"
            
            
        case .Phone:
            pageTitle.text = "Enter Phone Number"
            pageDesc.text = "You have not registered for OTP. Enter your phone number below to register"
            pinInput.placeholder = "Phone Number"
            pinInput.isSecureTextEntry = false
            MAX_TEXT_LENGTH = 11

            
        }
    
    // super.init(nibName: nil, bundle: nil)
       
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
               replacementString string: String) -> Bool {

        guard let preText = textField.text as NSString?,
            preText.replacingCharacters(in: range, with: string).count <= MAX_TEXT_LENGTH else {
            return false
        }

        return true
    }
    
    required init?(coder: NSCoder) {
         super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        setupComponents()
    }
    
}
