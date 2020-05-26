//
//  CustomDatePicker.swift
//  Grease Monkey
//
//  Created by Jialin Wang on 6/5/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import UIKit

class CustomDatePicker: UIDatePicker {
    
    // the linked Text Field
    var zTextField: UITextField!
    
    convenience init(textField: UITextField, textColor: UIColor) {
        
        self.init()
        
        // bar buttons
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let todayBtn = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayPressed))
        let flexBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        
        // form the appearance of the Date Picker
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        toolbar.barStyle = .black
        toolbar.isTranslucent = true
        toolbar.tintColor = .white
        toolbar.backgroundColor = .lightGray
        
        label.textColor = textColor
        label.textAlignment = .left
        label.text = "Select a Date"
        let labelBtn = UIBarButtonItem(customView: label)
        
        toolbar.setItems([todayBtn, flexBtn, labelBtn, flexBtn, doneBtn], animated: true)
        
        self.datePickerMode = .date
        self.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        
        // link up the Text Field
        zTextField = textField
        zTextField.inputAccessoryView = toolbar
        zTextField.inputView = self
    }
    
    @objc func donePressed() {
        
        self.zTextField.text = U.getFormattedDate(date: self.date)
        
        self.zTextField.resignFirstResponder()
        
    }
    
    @objc func todayPressed() {
        
        self.date = K.today
        self.zTextField.text = U.getFormattedDate(date: K.today)
    }
    
    @objc func valueChanged(sender: UIDatePicker) {
        
        self.zTextField.text = U.getFormattedDate(date: self.date)
        self.resignFirstResponder()
    }
    
}
