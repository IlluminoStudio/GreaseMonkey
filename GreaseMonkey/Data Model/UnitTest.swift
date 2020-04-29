//
//  UnitTest.swift
//  GreaseMonkey
//
//  Created by user on 21/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import Foundation
import RealmSwift

class UnitTest {
    
    func runUnitTest() {
        
        //detailedCheckUnitTest(u.A0, correctTotalWorkDay: -999, correctDaysLeft: -999, correctPercentageComplete: 0.0)
        
        // pool of test jobs
        var testJobsAllDone = [Job]()
        testJobsAllDone.append(Job(value: [K.tableFields.jobName: "rear window", K.tableFields.jobDone: true]))
        testJobsAllDone.append(Job(value: [K.tableFields.jobName: "tint window", K.tableFields.jobDone: true]))
        testJobsAllDone.append(Job(value: [K.tableFields.jobName: "right front mirror", K.tableFields.jobDone: true]))
        
        var testJobsPartialDone = [Job]()
        testJobsPartialDone.append(Job(value: [K.tableFields.jobName: "rear window", K.tableFields.jobDone: false]))
        testJobsPartialDone.append(Job(value: [K.tableFields.jobName: "tint window", K.tableFields.jobDone: true]))
        testJobsPartialDone.append(Job(value: [K.tableFields.jobName: "right front mirror", K.tableFields.jobDone: true]))
        
        var testJobsNoneDone = [Job]()
        testJobsNoneDone.append(Job(value: [K.tableFields.jobName: "rear window", K.tableFields.jobDone: false]))
        testJobsNoneDone.append(Job(value: [K.tableFields.jobName: "tint window", K.tableFields.jobDone: false]))
        testJobsNoneDone.append(Job(value: [K.tableFields.jobName: "right front mirror", K.tableFields.jobDone: false]))
        
        // pool of test cars
        var testCars = [Car]()
        var testCar: Car
        
        // GREEN Cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "532GRN"
            , K.tableFields.dateCheckIn: K.lastWeek!
            , K.tableFields.datePromised: K.yesterday!
        ])
        
        testJobsAllDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 2
        testCar = Car(value: [K.tableFields.rego: "632GRN"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.tomorrow!
        ])
        
        testJobsAllDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 3
        testCar = Car(value: [K.tableFields.rego: "452GRN"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.nextWeek!
        ])
        
        testJobsAllDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 4
        testCar = Car(value: [K.tableFields.rego: "385GRN"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.twoDaysLater!
        ])
        
        testJobsPartialDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 5
        testCar = Car(value: [K.tableFields.rego: "063GRN"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.nextWeek!
        ])
        
        testJobsNoneDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // RED cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "142RED"
            , K.tableFields.dateCheckIn: K.yesterday!
            , K.tableFields.datePromised: K.yesterday!
        ])
        
        testJobsPartialDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 2
        testCar = Car(value: [K.tableFields.rego: "942RED"
            , K.tableFields.dateCheckIn: K.lastWeek!
            , K.tableFields.datePromised: K.twoDaysAgo!
        ])
        
        testJobsNoneDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // YELLOW cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "718YLW"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.today
        ])
        
        testJobsNoneDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 2
        testCar = Car(value: [K.tableFields.rego: "293YLW"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.tomorrow!
        ])
        
        testJobsPartialDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // GREY cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "900GRY"
            , K.tableFields.dateCheckIn: K.today
        ])
        
        testCars.append(testCar)
        
        // ---------------------------------------------------
        
        // write to db
        let realm = try! Realm()
        
        try! realm.write {realm.deleteAll()}
        for testCar in testCars {
            do {
                try realm.write {
                    realm.add(testCar)
                }
            } catch {
                print("*** Error writing test car \(testCar.rego). \(error)")
            }
        }
    }
    
    private func detailedCheckUnitTest(_ theCar: Car, correctTotalWorkDay: Int, correctDaysLeft: Int, correctPercentageComplete: Double) {
        print("---------------------------")
        theCar.printCar()
        print("A1 rego: \(theCar.rego), totalWorkDay: \(theCar.totalWorkDay) days, daysLeft: \(theCar.daysLeft) days, percentageComplete: \(theCar.percentageComplete)")
        print("---------------------------\n\n")
        assert(theCar.totalWorkDay == correctTotalWorkDay)
        assert(theCar.daysLeft == correctDaysLeft)
        assert(abs(theCar.percentageComplete - correctPercentageComplete) < 0.000001)
    }
}

