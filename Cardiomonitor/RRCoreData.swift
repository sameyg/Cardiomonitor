//
//  RRCoreData.swift
//  Cardiomonitor
//
//  Created by Samantha Amey-Gonzalez on 8/11/18.
//  Copyright © 2018 RVC. All rights reserved.
//

import Foundation
import CoreData

class RR : NSManagedObject {
    @NSManaged var date: NSDate
    @NSManaged var rrCDM: Int
    @NSManaged var time: NSDate
}
