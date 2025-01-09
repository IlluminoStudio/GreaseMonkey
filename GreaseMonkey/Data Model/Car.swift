//
//  Car.swift
//  GreaseMonkey
//
//  Created by Jialin Wang on 14/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import Foundation
import RealmSwift

class Car: Object {
    @objc dynamic var rego: String = ""
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var datePromised: Date?
    @objc dynamic var dateCheckIn: Date = Date()
    @objc dynamic var customer: String? = ""
    @objc dynamic var contact: String? = ""
    @objc dynamic var notes: String? = ""
    
    let jobs = List<Job>()
    
    var hasFlagged: Bool! {
        for job in jobs {
            if job.flagged == true {
                return true
            }
        }
        
        return false
    }
    
    var coreStatus: String {
        
        var s: String = "NA"
        
        if hasFlagged {
            s = "special"
        } else if datePromised == nil {
            s = ""
        } else if aggregatedStatus == K.carStatusPurple {
            s = "due \(-1 * daysLeft) day" + ((-1 * daysLeft) > 1 ? "s" : "" + " ago")
        } else {
            if daysLeft == 0 {
                s = "due today"
            } else if daysLeft == 1 {
                s = "due tomorrow"
            } else if daysLeft < 0 {
                s = "\(-1 * daysLeft) day" + "\((-1 * daysLeft) > 1 ? "s" : "")" + " overdue"
            }
            else {
                s = "\(daysLeft) days left"
            }
        }
        
        return s
        
        //        var statusMessage: String
        //
        //        if currentCar.hasFlagged {
        //            statusMessage = "* Special [See case notes]"
        //        } else if currentCar.datePromised == nil {
        //            statusMessage = "NA (missing Date Promised)"
        //        } else if currentCar.aggregatedStatus == K.carStatusPurple {
        //            statusMessage = "Pick up ready\ndue \(-1 * daysLeft) day" + ((-1 * daysLeft) > 1 ? "s" : "" + " ago")
        //        } else {
        //
        //            statusMessage = "Target is \(U.getFormattedDate(with: K.dateFormatShortter, date: currentCar.datePromised))"
        //
        //            if daysLeft == 0 {
        //                statusMessage += "\n due today"
        //            } else if daysLeft == 1 {
        //                statusMessage += "\n due tomorrow"
        //            } else if daysLeft < 0 {
        //                statusMessage += "\n" + "\(-1 * daysLeft) day" + "\((-1 * daysLeft) > 1 ? "s" : "")" + " overdue"
        //            }
        //            else {
        //                statusMessage += "\n\(daysLeft) days left"
        //            }
        //        }
        //        cell.messageLabel.text = statusMessage
    }
    
    var color: UIColor? {
        var c = UIColor(named: K.BrandColors.BrandGreen)
        
        if aggregatedStatus == K.carStatusGreen {
            c = UIColor(named: K.BrandColors.BrandGreen)
        } else if aggregatedStatus == K.carStatusOrange {
            c = UIColor(named: K.BrandColors.BrandOrange)
        } else if aggregatedStatus == K.carStatusRed {
            c = UIColor(named: K.BrandColors.BrandRed)
        } else if aggregatedStatus == K.carStatusPurple {
            c = UIColor(named: K.BrandColors.BrandPurple)
        } else {
            c = UIColor(named: K.BrandColors.BrandGrey)
        }
        
        return c
    }
    
    var aggregatedStatus: Int {
        var ags = K.carStatusGreen
        
        if hasFlagged == true {
            ags = K.carStatusRed // commander override, highest priority
        } else if datePromised == nil {
            ags = K.carStatusGrey
        } else if percentageComplete >= 1.0 {
            if U.compareDateOnly(date1: K.today, date2: datePromised!) == K.DateCompare.Later {
                ags = K.carStatusPurple // car done, however customer pick-up overdue
            } else {
                ags = K.carStatusGreen // car done, customer haven't pick-up, so no worries
            }
        } else if datePromised == nil {
            ags = K.carStatusGrey
        } else if daysLeft < 0 { // overdue
            ags = K.carStatusRed
        } else if daysLeft < 2 { // deadline approaching
            ags = K.carStatusOrange
        } else { // not done, but not duing soon, so no worries
            ags = K.carStatusGreen
        }
        
        return ags
    }
    
    var totalWorkDay: Int {
        if let itsDatePromised = datePromised {
            return daysBetween(date1: dateCheckIn, date2: itsDatePromised) + 1 /*today to today is 1 work day*/
        } else {
            return -999
        }
        
    }
    
    var daysLeft: Int {
        if let itsDatePromised = datePromised {
            return daysBetween(date1: Date(), date2: itsDatePromised)
        } else {
            return -999
        }
    }
    
    var percentageComplete: Double {
        
        let totalJobs = jobs.count
        if totalJobs > 0 {
            var doneJobs = 0
            
            for job in jobs {
                if job.done {doneJobs += 1}
            }
            return Double(doneJobs) / Double(totalJobs)
        } else {
            return 0.0
        }
        
    }
    
    private func daysBetween(date1: Date, date2: Date) -> Int {
        
        let calendar = Calendar.current
        
        let cDate1 = calendar.startOfDay(for: date1)
        let cDate2 = calendar.startOfDay(for: date2)
        
        let distance = calendar.dateComponents([.day], from: cDate1, to: cDate2).day ?? -999
        
        return distance
    }
    
    func printCar() {
        print("Rego: \(rego)")
        print("dateCreated: \(U.getFormattedDate(with: K.dateFormatLong, date: dateCreated))")
        print("datePromised: \(U.getFormattedDate(with: K.dateFormatLong, date: datePromised))")
        print("dateCheckIn: \(U.getFormattedDate(with: K.dateFormatLong, date: dateCheckIn))")
        print("customer: \(customer!)")
        print("contact: \(contact!)")
        print("notes: \(notes!)")
        print("AGS: \(aggregatedStatus)")
    }
}
