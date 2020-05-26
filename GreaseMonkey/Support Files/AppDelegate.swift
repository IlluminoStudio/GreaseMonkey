//
//  AppDelegate.swift
//  GreasMonkey
//
//  Created by user on 14/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

//var AppFontSize: CGFloat = 8 // deliberately set default to a small font in order to detect runtime errors
//var AppFontSizeIndex = -1

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm file location not defined")
        
        do {
            _ /*(realm)*/ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
//        if UserDefaults.standard.object(forKey: K.userDefaultFontSizeIndex) == nil {
//            K.Defaults.set(K.DefaultFontSizeIndex, forKey: K.userDefaultFontSizeIndex)
//        }
//
//        AppFontSizeIndex = K.Defaults.integer(forKey: K.userDefaultFontSizeIndex)
//        AppFontSize = CGFloat(K.FontSize[AppFontSizeIndex])
        
        return true
    }
}

