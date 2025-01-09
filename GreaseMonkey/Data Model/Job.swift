//
//  Job.swift
//  GreaseMonkey
//
//  Created by Jialin Wang on 14/4/20.
//  Copyright © 2020 Test Co. All rights reserved.
//

import Foundation
import RealmSwift

class Job: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var flagged: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    
    var parentCar = LinkingObjects(fromType: Car.self, property: K.tableFields.jobs)
}
