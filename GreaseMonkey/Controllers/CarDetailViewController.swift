//
//  CarDetailViewController.swift
//  GreaseMonkey
//
//  Created by Jialin Wang on 16/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import Foundation
import RealmSwift
import SwipeCellKit

class CarDetailViewController: UIViewController {
    
    @IBOutlet weak var dateCreateLabel: UILabel!
    @IBOutlet weak var dateCheckInLabel: UILabel!
    @IBOutlet weak var datePromisedLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var jobsLabel: UILabel!    
    @IBOutlet weak var jobPlusSignLabel: UIButton!
    
    @IBOutlet weak var dateCreateLabelLeft: UILabel!
    @IBOutlet weak var dateCheckInTextField: UITextField!
    @IBOutlet weak var datePromisedTextField: UITextField!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var screenColor = UIColor.systemGray
    
    var jobs: Results<Job>?
    
    var selectedCar: Car? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        notesTextView.delegate = self
        
        tableView.register(UINib(nibName: K.jobCellNibName, bundle: nil), forCellReuseIdentifier: K.jobCellIdentifier)
        
        //_ = CustomDatePicker(textField: datePromisedTextField)
        _ = CustomDatePicker(textField: datePromisedTextField, textColor: screenColor)
        _ = CustomDatePicker(textField: dateCheckInTextField, textColor: screenColor)
        
        // long press handling
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.tableView.addGestureRecognizer(longPressGesture)
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = screenColor
        self.navigationItem.standardAppearance = navBarAppearance
        
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        
        if indexPath != nil, longPressGesture.state == UIGestureRecognizer.State.began {
            
            if let jobItem = jobs?[indexPath!.row] {
                
                let realm = try! Realm()
                do {
                    try realm.write {
                        jobItem.flagged = !jobItem.flagged
                    }
                } catch {
                    print("Error saving flag status. \(error)")
                }
            }
            
            tableView.reloadData()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.tintColor = screenColor
        
        self.title = "\(selectedCar?.rego ?? "Unknown Car")" + " - \(selectedCar?.coreStatus ?? "NA")"
        
        dateCreateLabel.text = U.getFormattedDate(with: K.dateFormatLong, date: selectedCar?.dateCreated ?? Date())
        dateCheckInTextField.text = U.getFormattedDate(date: selectedCar?.dateCheckIn)
        datePromisedTextField.text = U.getFormattedDate(date: selectedCar?.datePromised)
        customerTextField.text = selectedCar?.customer
        contactTextField.text = selectedCar?.contact
        statusLabel.text = ""
        
        notesTextView.text = selectedCar?.notes
        if notesTextView.text != "" {
            notesTextView.textColor = .label
        } else {
            notesTextView.text = K.notesPlaceHolder
            notesTextView.textColor = .placeholderText
        }
        
        loadJobs()
    }
    
    func loadJobs() {
        
        jobs = selectedCar?.jobs.sorted(byKeyPath: K.tableFields.jobDateCreated, ascending: true)
        
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add New Job", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new job"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Job", style: .default) { (action) in
            
            if let currentCar = self.selectedCar {
                
                let realm = try! Realm()
                do {
                    try realm.write {
                        let newJob = Job()
                        newJob.name = textField.text!
                        currentCar.jobs.append(newJob)
                    }
                    
                } catch {
                    print("Error saving new job. \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func updateCarPressed(_ sender: Any) {
        
        if let safeSelectedCar = selectedCar {
            // 1. TRY to convert
            let newCheckInDate = U.stringToDate(dateCheckInTextField.text!)
            let newPromisedDate = U.stringToDate(datePromisedTextField.text!)
            let newCustomer = customerTextField.text
            let newContact = contactTextField.text
            let newNotes = notesTextView.text!
            
            // 2. validate
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
                // validation - promised date must not be before check-in date
                if U.compareDateOnly(date1: newPromisedDate, date2: newCheckInDate) < 0 {
                    statusLabel.text = "Promised Date cannot be before Check-in Date"
                    
                    return
                }
            }
            
            // write to db
            DispatchQueue.main.async {
                let realm = try! Realm()
                do {
                    try realm.write {
                        safeSelectedCar.dateCheckIn = newCheckInDate
                        safeSelectedCar.datePromised = newPromisedDate
                        safeSelectedCar.customer = newCustomer
                        safeSelectedCar.contact = newContact
                        safeSelectedCar.notes = newNotes
                    }
                    
                    self.statusLabel.text = "Updated car \(safeSelectedCar.rego)"
                } catch {
                    print("Error updating car. \(error)")
                }
            }
        }
    }
    
}

extension CarDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.jobCellIdentifier, for: indexPath) as! JobCell
        cell.delegate = self
        
        if let jobItem = jobs?[indexPath.row] {
            
            cell.nameLabel.text = jobItem.name
            cell.tickImg.isHidden = jobItem.done ? false : true
            cell.flagImg.isHidden = jobItem.flagged ? false : true
            
        } else {
            
            cell.nameLabel?.text = "No Jobs Added Yet"
        }
        
        return cell
    }
}

extension CarDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let jobItem = jobs?[indexPath.row] {
            
            let realm = try! Realm()
            do {
                try realm.write {
                    jobItem.done = !jobItem.done
                }
            } catch {
                print("Error saving done status. \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CarDetailViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // query database using user input
        jobs = jobs?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: K.tableFields.jobDateCreated, ascending: false)
        tableView.reloadData()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder() // searchBar no longer cleaims foreground (retract of keyboard)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if user has cleared the search box -> full listing
        if searchBar.text?.count == 0 {
            loadJobs()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // searchBar no longer cleaims foreground (retract of keyboard)
            }
        }
    }
    
    
}

extension CarDetailViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let delJob = self.jobs?[indexPath.row] {
                
                let realm = try! Realm()
                do {
                    try realm.write {
                        realm.delete(delJob)
                    }
                    
                } catch {
                    print("Error deleting job '\(delJob.name)'. \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        return [deleteAction]
    }
}

extension CarDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.text == K.notesPlaceHolder {
            notesTextView.text = ""
            notesTextView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTextView.text == "" {
            notesTextView.text = K.notesPlaceHolder
            notesTextView.textColor = .placeholderText
        }
    }
}
