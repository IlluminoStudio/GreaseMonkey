//
//  Constants.swift
//  GreaseMonkey
//
//  Created by Jialin Wang on 14/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import Foundation

struct K {
    
    static let appName = "GreaseMonkey"
    static let addCarSegue = "goToAddCar"
    static let carDetailSegue = "goToCarDetail"
    
    static let carCellIdentifier = "CarReusableCell"
    static let carCellNibName = "CarCell"
    
    static let jobCellIdentifier = "JobReusableCell"
    static let jobCellNibName = "JobCell"
    
    static let carDetailCellName = "CarDetailCell"
    
    static let dateFormatLong = "E d MMM, yyyy hh:mm a"
    static let dateFormatShort = "E d MMM, yyyy"
    static let dateFormatShortter = "E d MMM"
    
    static let calendar = Calendar.current
    static let DF = DateFormatter()
    
    // handles car cases up to 2 years old
    static let oldestDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * 365 * 2)
    
    static let carStatusRed = 2
    static let carStatusOrange = 1
    static let carStatusGreen = 0
    static let carStatusGrey = -1
    static let carStatusPurple = 99
    
    static let notesPlaceHolder = "Type in notes for this car"
    
    struct BrandColors {
        static let BrandRed = "BrandRed"
        static let BrandYellow = "BrandYellow"
        static let BrandGreen = "BrandGreen"
        static let BrandGrey = "BrandGrey"
        static let BrandOrange = "BrandOrange"
        static let BrandBackground = "BrandGround"
        static let BrandPurple = "BrandPurple"
    }
    
    struct JobStatus {
        static let AllDone = 2
        static let PartiallyDone = 1
        static let AllNotDone = 0
    }
    
    struct DateCompare {
        static let Later = 1
        static let Earlier = -1
        static let SameDay = 0
    }
    
    struct tableFields {
        static let rego = "rego"
        static let dateCreated = "dateCreated"
        static let datePromised = "datePromised"
        static let dateCheckIn = "dateCheckIn"
        static let customer = "customer"
        static let contact = "contact"
        static let jobs = "jobs"
        static let jobName = "name"
        static let jobDone = "done"
        static let jobFlagged = "flagged"
        static let jobDateCreated = "dateCreated"
        static let notes = "notes"
    }
    
    static let today = Date()
    static let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
    static let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
    static let lastWeek = calendar.date(byAdding: .day, value: -7, to: Date())!
    static let nextWeek = calendar.date(byAdding: .day, value: 7, to: Date())!
    static let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
    static let twoDaysLater = calendar.date(byAdding: .day, value: 2, to: Date())!
    
    func getFormattedDate(with format: String = K.dateFormatShort, date: Date = Date()) -> String {
        
        K.DF.dateFormat = format
        K.DF.dateStyle = .medium
        K.DF.timeStyle = .none
        
        return K.DF.string(from: date)
        
    }
}
