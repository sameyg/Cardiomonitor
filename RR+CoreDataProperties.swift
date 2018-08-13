//
//  RR+CoreDataProperties.swift
//  Cardiomonitor
//
//  Created by Samantha Amey-Gonzalez on 8/11/18.
//  Copyright © 2018 RVC. All rights reserved.
//
//

import Foundation
import CoreData


extension RR {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RR> {
        return NSFetchRequest<RR>(entityName: "RR")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var rrdata: Int16
    @NSManaged public var time: NSDate?

}
