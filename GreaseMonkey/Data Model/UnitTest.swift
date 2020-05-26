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
        testJobsAllDone.append(Job(value: [K.tableFields.jobName: "rear window", K.tableFields.jobDone: true, K.tableFields.jobFlagged: false]))
        testJobsAllDone.append(Job(value: [K.tableFields.jobName: "tint window", K.tableFields.jobDone: true, K.tableFields.jobFlagged: false]))
        testJobsAllDone.append(Job(value: [K.tableFields.jobName: "right front mirror", K.tableFields.jobDone: true, K.tableFields.jobFlagged: false]))
        
        var testJobsPartialDone = [Job]()
        testJobsPartialDone.append(Job(value: [K.tableFields.jobName: "rear window", K.tableFields.jobDone: false, K.tableFields.jobFlagged: false]))
        testJobsPartialDone.append(Job(value: [K.tableFields.jobName: "tint window", K.tableFields.jobDone: true, K.tableFields.jobFlagged: false]))
        testJobsPartialDone.append(Job(value: [K.tableFields.jobName: "right front mirror", K.tableFields.jobDone: true, K.tableFields.jobFlagged: false]))
        
        var testJobsNoneDone = [Job]()
        testJobsNoneDone.append(Job(value: [K.tableFields.jobName: "rear window", K.tableFields.jobDone: false, K.tableFields.jobFlagged: false]))
        testJobsNoneDone.append(Job(value: [K.tableFields.jobName: "tint window", K.tableFields.jobDone: false, K.tableFields.jobFlagged: false]))
        testJobsNoneDone.append(Job(value: [K.tableFields.jobName: "right front mirror", K.tableFields.jobDone: false, K.tableFields.jobFlagged: false]))
        
        // pool of flagged jobs
        var testJobsAllFlagged = [Job]()
        testJobsAllFlagged.append(Job(value: [K.tableFields.jobName: "rear headlight", K.tableFields.jobDone: true, K.tableFields.jobFlagged: true]))
        testJobsAllFlagged.append(Job(value: [K.tableFields.jobName: "front bumper bar", K.tableFields.jobDone: false, K.tableFields.jobFlagged: true]))
        testJobsAllFlagged.append(Job(value: [K.tableFields.jobName: "back door", K.tableFields.jobDone: false, K.tableFields.jobFlagged: true]))
        
        var testJobsNoneFlagged = [Job]()
        testJobsNoneFlagged.append(Job(value: [K.tableFields.jobName: "rear headlight", K.tableFields.jobDone: false, K.tableFields.jobFlagged: false]))
        testJobsNoneFlagged.append(Job(value: [K.tableFields.jobName: "front bumper bar", K.tableFields.jobDone: true, K.tableFields.jobFlagged: false]))
        testJobsNoneFlagged.append(Job(value: [K.tableFields.jobName: "back door", K.tableFields.jobDone: false, K.tableFields.jobFlagged: false]))
        
        var testJobsPartialFlagged = [Job]()
        testJobsPartialFlagged.append(Job(value: [K.tableFields.jobName: "rear headlight", K.tableFields.jobDone: true, K.tableFields.jobFlagged: true]))
        testJobsPartialFlagged.append(Job(value: [K.tableFields.jobName: "front bumper bar", K.tableFields.jobDone: true, K.tableFields.jobFlagged: false]))
        testJobsPartialFlagged.append(Job(value: [K.tableFields.jobName: "back door", K.tableFields.jobDone: false, K.tableFields.jobFlagged: false]))
        
        
        // pool of test cars
        var testCars = [Car]()
        var testCar: Car
        var flaggedCar: Car
        
        // PURPLE Cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "532PPL"
            , K.tableFields.dateCheckIn: K.lastWeek
            , K.tableFields.datePromised: K.yesterday
        ])
        
        testJobsAllDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // GREEN Cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "632GRN"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.tomorrow
            , K.tableFields.notes: "Donec sit amet magna sem"
        ])
        
        testJobsAllDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 2
        testCar = Car(value: [K.tableFields.rego: "452GRN"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.nextWeek
        ])
        
        testJobsAllDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 3
        testCar = Car(value: [K.tableFields.rego: "385GRN"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.twoDaysLater
        ])
        
        testJobsPartialDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 4
        testCar = Car(value: [K.tableFields.rego: "063GRN"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.nextWeek
        ])
        
        testJobsNoneDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // RED cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "142RED"
            , K.tableFields.dateCheckIn: K.yesterday
            , K.tableFields.datePromised: K.yesterday
        ])
        
        testJobsPartialDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 2
        testCar = Car(value: [K.tableFields.rego: "942RED"
            , K.tableFields.dateCheckIn: K.lastWeek
            , K.tableFields.datePromised: K.twoDaysAgo
        ])
        
        testJobsNoneDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // ORANGE cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "718ORG"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.today
        ])
        
        testJobsNoneDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // car 2
        testCar = Car(value: [K.tableFields.rego: "293ORG"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.tomorrow
        ])
        
        testJobsPartialDone.forEach{testCar.jobs.append($0)}
        testCars.append(testCar)
        
        // GREY cases
        // car 1
        testCar = Car(value: [K.tableFields.rego: "900GRY"
            , K.tableFields.dateCheckIn: K.today
        ])
        
        testCars.append(testCar)
        
        // FLAGGED cases
        // car 1 - override purple
        flaggedCar = Car(value: [K.tableFields.rego: "510FLG"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.tomorrow
            , K.tableFields.notes: "Aliquam id tincidunt mauris, ac fermentum urna. Quisque neque mauris, auctor id pellentesque eget, feugiat ut sapien. Duis blandit ornare blandit. Nullam interdum ligula in velit gravida, eu vestibulum lectus commodo. Proin lobortis massa nec odio tincidunt, non sollicitudin libero pharetra."
        ])
        
        testJobsAllFlagged.forEach{flaggedCar.jobs.append($0)}
        testCars.append(flaggedCar)
        
        // car 2 - override red
        flaggedCar = Car(value: [K.tableFields.rego: "716FLG"
            , K.tableFields.dateCheckIn: K.twoDaysAgo
            , K.tableFields.datePromised: K.yesterday
            , K.tableFields.notes: "Aliquam id tincidunt mauris, ac fermentum urna. Quisque neque mauris, auctor id pellentesque eget, feugiat ut sapien. Duis blandit ornare blandit. Nullam interdum ligula in velit gravida, eu vestibulum lectus commodo. Proin lobortis massa nec odio tincidunt, non sollicitudin libero pharetra."
        ])
        
        testJobsPartialFlagged.forEach{flaggedCar.jobs.append($0)}
        testCars.append(flaggedCar)
        
        // car 3 - override orange
        flaggedCar = Car(value: [K.tableFields.rego: "213FLG"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.today
            , K.tableFields.notes: "了美器打已书识，力Y于点8"
        ])
        
        testJobsPartialFlagged.forEach{flaggedCar.jobs.append($0)}
        testCars.append(flaggedCar)
        
        // car 4 - override green
        flaggedCar = Car(value: [K.tableFields.rego: "114FLG"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.datePromised: K.nextWeek
            , K.tableFields.notes: "候整五革例组交深经住集王报却调"
        ])
        
        testJobsAllFlagged.forEach{flaggedCar.jobs.append($0)}
        testCars.append(flaggedCar)
        
        // car 5 - override grey
        flaggedCar = Car(value: [K.tableFields.rego: "413FLG"
            , K.tableFields.dateCheckIn: K.today
            , K.tableFields.notes: "Aliquam id tincidunt mauris, ac fermentum urna. Quisque neque mauris, auctor id pellentesque eget, feugiat ut sapien. Duis blandit ornare blandit. Nullam interdum ligula in velit gravida, eu vestibulum lectus commodo. Proin lobortis massa nec odio tincidunt, non sollicitudin libero pharetra."
        ])
        
        testJobsPartialFlagged.forEach{flaggedCar.jobs.append($0)}
        testCars.append(flaggedCar)
        
        
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

