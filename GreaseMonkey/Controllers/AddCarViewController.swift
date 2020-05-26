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
    
    // labels
    @IBOutlet weak var regoLabel: UILabel!
    @IBOutlet weak var dateCheckInLabel: UILabel!
    @IBOutlet weak var datePromisedLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    // user input fields
    @IBOutlet weak var regoTextField: UITextField!
    @IBOutlet weak var dateCheckInTextField: UITextField!
    @IBOutlet weak var datePromisedTextField: UITextField!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    let newCar = Car()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        clearView()
        
        _ = CustomDatePicker(textField: datePromisedTextField, textColor: self.view.tintColor)
        _ = CustomDatePicker(textField: dateCheckInTextField, textColor: self.view.tintColor)
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        U.printSizeReport(self)
    //
    //    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        U.printSizeReport(self)
    }
    
    private func clearView() {
        
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
                
                // pop a confirmation (deliberately to slow down work flow)
                let alert = UIAlertController(title: "Created car \(newCarRego!)", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } catch {
                let errMsg = "*** Error creating new car. \(error)"
                self.statusLabel.text = errMsg
            }
        }
        
        
    }
}
