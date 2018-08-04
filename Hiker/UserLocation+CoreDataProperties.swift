//
//  UserLocation+CoreDataProperties.swift
//  Hiker
//
//  Created by Andrew James on 8/3/18.
//  Copyright © 2018 aj. All rights reserved.
//
//

import Foundation
import CoreData


extension UserLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLocation> {
        return NSFetchRequest<UserLocation>(entityName: "UserLocation")
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var timestamp: NSDate?

}
