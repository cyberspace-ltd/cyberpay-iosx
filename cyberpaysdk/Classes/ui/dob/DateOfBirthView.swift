//
//  DateOfBirthView.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 19/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MaterialComponents.MaterialBottomSheet


internal class DateOfBirthView : MDCBottomSheetController {
    
    
    // Age of 18.
    let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!;
    
    // Age of 100.
    let MAXIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -100, to: Date())!;
    
    let datePicker: UIDatePicker = UIDatePicker()
    
    let  txtDatePicker: UITextField = UITextField()
    
    let footerLabel = UILabel()
    
    var label: String  = "BIRTH DATE"
    
    var footer: String  = "We use your date of birth to ensure that the account belongs to you"
    
    private var dateOfBirth = ""
    
    private var uiController : UIViewController?
    
    private var onSubmitted : ((String) -> Void)?
    
    func validateButtonPressed(_ sender: Any) {
        let isValidAge = validateAge(birthDate: datePicker.date);
        
        if isValidAge {
            
            let replaced = dateOfBirth.replacingOccurrences(of: "/", with: "")
            
            self.onSubmitted!(replaced)
            self.dismiss(animated: true, completion: nil)
            
            
        } else {
            showAlert(title: "Invalid Age", message: "Must be between 18 and 100 years old");
        }
    }
    
    init(contentViewController: UIViewController, message: String, onSubmit: @escaping (String)->()) {
        super.init(contentViewController: contentViewController)
        
        if  !message.isEmpty {
            
            footerLabel.text = message
        }
        onSubmitted = onSubmit
        uiController = contentViewController
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissOnDraggingDownSheet = false
        self.dismissOnBackgroundTap = false
        datePicker.maximumDate = MINIMUM_AGE;
        datePicker.minimumDate = MAXIMUM_AGE;
        
        
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let primaryColorDark = UIColor(hex: "#ff16283E")
        toolbar.barTintColor = primaryColorDark
        toolbar.backgroundColor = primaryColorDark
        
        
        let lightGray = UIColor.gray
        let lightGrayTrans = UIColor.withAlphaComponent(lightGray)(0.6)
        //done button & cancel button
        
        let doneButton = UIBarButtonItem(title: "Continue", style: .done, target: nil, action: Selector(("donedatePicker")))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem = doneButton
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("cancelDatePicker")))
        toolbar.setItems([doneButton,spaceButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        if #available(iOS 13.0, *) {
            txtDatePicker.backgroundColor = UIColor.systemGray6
        } else {
            // Fallback on earlier versions
            
            txtDatePicker.backgroundColor = lightGrayTrans
            
        }
        
        txtDatePicker.inputView = datePicker
        txtDatePicker.setCorner(radius: 4)
        if #available(iOS 13.0, *) {
            txtDatePicker.setBorder(width: 2, color: UIColor.systemGray6)
        }
        
        
        _ = txtDatePicker.setView(UITextField.ViewType.left, space: 16)
        _ = txtDatePicker.setView(UITextField.ViewType.right, space: 16)
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(DateOfBirthView.datePickerValueChanged(_:)), for: .valueChanged)
        
        
        //Text Label
        let textLabel = UILabel()
        textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        textLabel.text  = ""
        textLabel.textAlignment = .left
        textLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        
        
        //Desc Label
        let descriptionLabel = UILabel()
        descriptionLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        descriptionLabel.text  = "\(label)"
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout)
        let black = UIColor.black
        let blackTrans = UIColor.withAlphaComponent(black)(0.87)
        descriptionLabel.textColor = blackTrans
        
        footerLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        footerLabel.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        footerLabel.text  = "\(footer)"
        footerLabel.textAlignment = .left
        footerLabel.backgroundColor  = UIColor.clear
        footerLabel.numberOfLines = 3
        footerLabel.lineBreakMode = .byWordWrapping
        footerLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
        footerLabel.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        let blackLight = UIColor.black
        let blackLightTrans = UIColor.withAlphaComponent(blackLight)(0.6)
        footerLabel.textColor = blackLightTrans
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.addArrangedSubview(txtDatePicker)
        stackView.addArrangedSubview(footerLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        
        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            footerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            footerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            txtDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            txtDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            txtDatePicker.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    
    @objc func donedatePicker(){
        
        
        validateButtonPressed(self)
        self.view.endEditing(true)
    }
    
    
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        dismiss(animated: true, completion: nil)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        
        // Apply date format
        dateOfBirth = dateFormatter.string(from: sender.date)
        
        txtDatePicker.text = dateOfBirth
    }
    
    
    func validateAge(birthDate: Date) -> Bool {
        var isValid: Bool = true;
        
        if birthDate < MAXIMUM_AGE || birthDate > MINIMUM_AGE {
            isValid = false;
        }
        
        return isValid;
    }
    
    func showAlert(title: String, message: String) {
        // Create alert controller.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        
        // Create alert action to add to controller.
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil);
        
        // Add action.
        alertController.addAction(alertAction);
        
        // Display alert.
        self.present(alertController, animated: true, completion: nil);
    }
}
