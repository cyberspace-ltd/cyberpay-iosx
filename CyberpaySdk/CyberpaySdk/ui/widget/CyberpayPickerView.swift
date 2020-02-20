//
//  CyberpayPickerView.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 19/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import UIKit

class CyberpayPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData : [String]!
    var pickerTextField : UITextField!
    var selectionHandler : ((_ selectedText: String) -> Void)?

    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: CGRect.zero)
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        
        self.delegate = self
        self.dataSource = self
        
        
        DispatchQueue.main.async {
            
            if pickerData.count != 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        }
        
        
        
    }
    

    convenience init(pickerData: [String], dropdownField: UITextField, onSelect selectionHandler : @escaping (_ selectedText: String) -> Void) {
      self.init(pickerData: pickerData, dropdownField: dropdownField)

      self.selectionHandler = selectionHandler
    
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
       
    
}


extension UITextField {
    func loadDropdownData(data: [String]) {
        self.inputView = CyberpayPickerView(pickerData: data, dropdownField: self)
    }
    
    func loadDropdownData(data: [String], onSelect selectionHandler : @escaping (_ selectedText: String) -> Void) {
        self.inputView = CyberpayPickerView(pickerData: data, dropdownField: self, onSelect: selectionHandler)
    }
}
