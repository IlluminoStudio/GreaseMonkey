//
//  CarViewController.swift
//  GreaseMonkey
//
//  Created by Jialin Wang on 14/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import UIKit
import RealmSwift
import Charts
import SwipeCellKit

class CarViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // initialise an access point to the common global realm database
    let realm = try! Realm()
    
    var cars: Results<Car>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120
        
        tableView.dataSource = self // souce delegate
        tableView.delegate = self // interaction agent delegate
        searchBar.delegate = self // search bar delegate
        
        tableView.separatorStyle = .none
        
        //navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.carCellNibName, bundle: nil), forCellReuseIdentifier: K.carCellIdentifier)
        
        let u = UnitTest()
        u.runUnitTest()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadCars()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: K.addCarSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.carDetailSegue {
            
            let destinationVC = segue.destination as! CarDetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCar = cars?[indexPath.row]
                destinationVC.screenColor = cars?[indexPath.row].color ?? UIColor.systemGray
            }
        }
        else if segue.identifier == K.addCarSegue {
            
        }
        else {
            fatalError("invalid segue")
        }
    }
    
    func loadCars() {
        cars = realm.objects(Car.self).sorted(byKeyPath: K.tableFields.rego, ascending: true)
        
        tableView.reloadData()
    }
}
    extension CarViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return regos.count
            return cars?.count ?? 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.carCellIdentifier, for: indexPath) as! CarCell
            cell.delegate = self
            
            if let currentCar = cars?[indexPath.row] {
                
                // flag
                cell.flagImg.isHidden = currentCar.hasFlagged ? false : true
                
                // rego label
                cell.regoLabel.text = currentCar.rego
                cell.regoLabel.textColor = currentCar.color
                
                // status message
                cell.messageLabel.textColor = currentCar.color
                var statusMessage: String
                
                if currentCar.hasFlagged {
                    statusMessage = "* Special\nsee car details"
                } else if currentCar.datePromised == nil {
                    statusMessage = "NA (missing Date Promised)"
                } else if currentCar.aggregatedStatus == K.carStatusPurple {
                    statusMessage = "Pick up ready\n\(currentCar.coreStatus)"
                } else {
                    
                    statusMessage = "Target is \(U.getFormattedDate(with: K.dateFormatShortter, date: currentCar.datePromised))\n\(currentCar.coreStatus)"
                }
                cell.messageLabel.text = statusMessage
                
                // progress bar
                cell.progressBar.tintColor = currentCar.color
                cell.progressBar.progress = 1 - Float(currentCar.daysLeft) / Float(currentCar.totalWorkDay)
                
                // pie chart
                let progress = currentCar.percentageComplete
                
                let pieChart = cell.pieChartView as! PieChartView
                
                pieChart.data = customizeChart(dataPoints: [".", ".."], values: [progress, 1 - progress], color: currentCar.color! )
                pieChart.legend.enabled = false
                pieChart.drawEntryLabelsEnabled = false
                
            } else {
                cell.regoLabel.text = "No Cars Added Yet"
            }
            
            return cell
        }
        
        func customizeChart(dataPoints: [String], values: [Double], color: UIColor = UIColor.systemGray) -> PieChartData {
            
            // 1. Set ChartDataEntry - stores the values of each element in an array
            var dataEntries: [ChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
                dataEntries.append(dataEntry)
            }
            
            // 2. Set ChartDataSet - use info from "1" to custom how to display them, here we only specify colors
            let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
            
            pieChartDataSet.colors = [color, UIColor.systemGray]
            
            // 3. Set ChartData - use info from "2" as the chart's data, here we also changing number formats, eg. 15.0 -> 15
            let pieChartData = PieChartData(dataSet: pieChartDataSet)
            
            let format = NumberFormatter()
            format.numberStyle = .none
            let formatter = DefaultValueFormatter(formatter: format)
            pieChartData.setValueFormatter(formatter)
            
            // 4. Assign "3" as the chart's data
            //pieChartView.data = pieChartData
            return pieChartData
        }
    }
    


extension CarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let cell = tableView.cellForRow(at: indexPath)
        //        cell?.backgroundColor = .red
        
        performSegue(withIdentifier: K.carDetailSegue, sender: self)
    }
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        print("--------- deselect cell at \(indexPath.row)")
    //
    //        let cell = tableView.cellForRow(at: indexPath)
    //        cell?.backgroundColor = .clear
    //    }
}

extension CarViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // query database using user input
        cars = cars?.filter("rego CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: K.tableFields.rego, ascending: true)
        tableView.reloadData()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder() // searchBar no longer cleaims foreground (retract of keyboard)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if user has cleared the search box -> full listing
        if searchBar.text?.count == 0 {
            loadCars()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // searchBar no longer cleaims foreground (retract of keyboard)
            }
        }
    }
    
}

extension CarViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let delCar = self.cars?[indexPath.row] {
                
                let realm = try! Realm()
                
                // del jobs
                for delJob in delCar.jobs {
                    do {
                        try realm.write {
                            realm.delete(delJob)
                        }
                    } catch {
                        print("Error deleting car job '\(delJob.name)'. \(error)")
                    }
                }
                
                // del car
                do {
                    try realm.write {
                        realm.delete(delCar)
                    }
                } catch {
                    print("Error deleting car '\(delCar.rego)'. \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}
