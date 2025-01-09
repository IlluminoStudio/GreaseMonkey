//
//  Utilities.swift
//  GreaseMonkey
//
//  Created by Jialin Wang on 16/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import UIKit

class U {
    static func getFormattedDate(with format: String = K.dateFormatShort, date: Date? = nil) -> String {
        
        K.DF.dateFormat = format
        
        if let correctDate = date {
            return K.DF.string(from: correctDate)
        }
        return ""
    }
    
    static func compareDateOnly(date1: Date, date2: Date) -> Int {
        var result: Int = 0
        
        let date1Start = K.calendar.startOfDay(for: date1)
        let date2Start = K.calendar.startOfDay(for: date2)
        if date1Start > date2Start {
            result = K.DateCompare.Later
        } else if date1Start < date2Start {
            result = K.DateCompare.Earlier
        } else {
            result = K.DateCompare.SameDay
        }
        
        return result
    }
    
    static func validateDateString(_ s: String, dateFormatStr: String = "E d MMM, yyyy") -> Bool {
        var result: Bool = false
        
        K.DF.dateFormat = dateFormatStr
        
        if let _ = K.DF.date(from: s) {
            result = true
        }
        
        return result
    }
    
    static func stringToDate(_ s: String, dateFormatStr: String = K.dateFormatShort) -> Date {
        
        K.DF.dateFormat = dateFormatStr
        
        let failedResult: Date = K.calendar.date(from: DateComponents(year: 1970, month: 12, day: 31))!
        
        if let sucResult = K.DF.date(from: s) {
            return sucResult
        }

        return failedResult
    }
    
    //usage: U.printSizeReport(self)
    static func printSizeReport(_ controller: UIViewController) {
        
        var sizeReport = ""
        
        sizeReport = "\(UIDevice.current.userInterfaceIdiom == .pad ? "pad" : "not pad")"
        
        let sizeClasses = ["U", "C", "R"]
        
        sizeReport += "   w\(sizeClasses[controller.traitCollection.horizontalSizeClass.rawValue]) h\(sizeClasses[controller.traitCollection.verticalSizeClass.rawValue])"
        
        if UIDevice.current.orientation.isPortrait {
            sizeReport += "   portrait"
        } else if UIDevice.current.orientation.isLandscape {
            sizeReport += "   landscape"
        } else {
            sizeReport += "   unknown orientation"
        }
        
        print(sizeReport)
    }

}
