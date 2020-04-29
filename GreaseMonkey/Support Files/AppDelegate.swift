//
//  AppDelegate.swift
//  GreasMonkey
//
//  Created by user on 14/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm file location not defined")
        
        do {
            // let realm = try Realm() // comment out to remove warning
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }
}

