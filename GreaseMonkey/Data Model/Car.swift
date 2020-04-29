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
    
    let jobs = List<Job>()
    
    var aggregatedStatus: Int {
        var ags = K.carStatusGreen
        
        if percentageComplete >= 1.0 { // all done, won't bother to look at the rest
            ags = K.carStatusGreen
        } else if datePromised == nil {
            ags = K.carStatusGrey
        } else if daysLeft < 0 { // overdue
            ags = K.carStatusRed
        } else if daysLeft < 2 { // deadline approaching
            ags = K.carStatusYellow
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
        print("AGS: \(aggregatedStatus)")
    }
}
