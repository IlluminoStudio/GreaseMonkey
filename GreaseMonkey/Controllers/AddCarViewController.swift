//
//  AddCarViewController.swift
//  GreaseMonkey
//
//  Created by Jialin Wang on 15/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import Foundation
import RealmSwift

class AddCarViewController: UIViewController {
    
    @IBOutlet weak var regoTextField: UITextField!
    @IBOutlet weak var dateCheckInTextField: UITextField!
    @IBOutlet weak var datePromisedTextField: UITextField!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    let datePicker_Promised = UIDatePicker()
    let datePicker_CheckIn = UIDatePicker()
    let newCar = Car()
    
    override func viewDidLoad() {
        
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        clearView()
        
        createDatePicker_Promised()
        createDatePicker_CheckIn()
    }
    
    func clearView() {
        
        datePromisedTextField.textAlignment = .center
        dateCheckInTextField.textAlignment = .center
        
        regoTextField.text = ""
        dateCheckInTextField.text = ""
        datePromisedTextField.text = ""
        statusLabel.text = ""
        customerTextField.text = ""
        contactTextField.text = ""
        
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        // 1. TRY to convert
        let newCarRego = regoTextField.text
        let newCheckInDate = U.stringToDate(dateCheckInTextField.text!)
        let newPromisedDate = U.stringToDate(datePromisedTextField.text!)
        let newCustomer = customerTextField.text
        let newContact = contactTextField.text
        
        // 2. validate
        // validation - must have rego
        if newCarRego == "" {
            statusLabel.text = "Rego cannot be empty"
            
            return
        }
        
        // validation - must have valid check-in date, and it cannot be over 1 year
        if U.compareDateOnly(date1: newCheckInDate, date2: K.oldestDate) < 0
        {
            statusLabel.text = "Must have valid Check-in Date"
            
            return
        }
        
        // validation - check in date cannot be in future
        if U.compareDateOnly(date1: newCheckInDate, date2: K.today) > 0 {
            statusLabel.text = "Check-in Date cannot be in future"
            
            return
        }
        
        // validation - if specified, validate promised date
        if datePromisedTextField.text != "" {
            
            // validation - promised date must be a valid date
            if U.compareDateOnly(date1: newPromisedDate, date2: K.oldestDate) < 0 {
                statusLabel.text = "If specified, Promised Date must be valid"
                
                return
            }
            // validation - promised date must not  be in the past
            if U.compareDateOnly(date1: newPromisedDate, date2: K.today) < 0 {
                statusLabel.text = "Promised Date for a new car cannot be in the past"
                
                return
            }
            // validation - promised date must not be before check-in date
            if U.compareDateOnly(date1: newPromisedDate, date2: newCheckInDate) < 0 {
                statusLabel.text = "Promised Date cannot be before Check-in Date"
                
                return
            }
        }
        
        // 3. write to db
        DispatchQueue.main.async {
            self.newCar.rego = newCarRego!
            self.newCar.dateCheckIn = newCheckInDate
            self.newCar.datePromised = (self.datePromisedTextField.text == "" ? nil : newPromisedDate)
            self.newCar.customer = newCustomer
            self.newCar.contact = newContact
            
            let realm = try! Realm()
            
            do {
                try realm.write {
                    realm.add(self.newCar)
                }
                self.clearView()
                self.statusLabel.text = "Created car \(newCarRego!)"
            } catch {
                let errMsg = "*** Error creating new car. \(error)"
                self.statusLabel.text = errMsg
            }
        }
    }
    
    func createDatePicker_Promised() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDonePressed_Promised))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toolbar
        datePromisedTextField.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        datePromisedTextField.inputView = datePicker_Promised
        
        // date picker mode
        datePicker_Promised.datePickerMode = .date
        datePicker_Promised.addTarget(self, action: #selector(datePickerValueChanged_Promised), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged_Promised() {
        
        datePromisedTextField.text = U.getFormattedDate(date: datePicker_Promised.date)
    }
    
    @objc func datePickerDonePressed_Promised() {
        
        datePromisedTextField.text = U.getFormattedDate(date: datePicker_Promised.date)
        self.view.endEditing(true)
    }
    
    func createDatePicker_CheckIn() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDonePressed_CheckIn))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toolbar
        dateCheckInTextField.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        dateCheckInTextField.inputView = datePicker_CheckIn
        
        // date picker mode
        datePicker_CheckIn.datePickerMode = .date
        datePicker_CheckIn.addTarget(self, action: #selector(datePickerValueChanged_CheckIn), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged_CheckIn() {
        
        dateCheckInTextField.text = U.getFormattedDate(date: datePicker_CheckIn.date)
        //newCar.dateCheckIn = datePicker_CheckIn.date
    }
    
    @objc func datePickerDonePressed_CheckIn() {
        dateCheckInTextField.text = U.getFormattedDate(date: datePicker_CheckIn.date)
        self.view.endEditing(true)        
        
    }
}
