//
//  UserLocation+CoreDataClass.swift
//  Hiker
//
//  Created by Andrew James on 8/3/18.
//  Copyright © 2018 aj. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

public class UserLocation: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    public var title: String? {
        DateFormatter.sharedFormatter.dateFormat = "MMMd-yy HH:mm"
        let date = (timestamp as Date?) ?? Date()
        return DateFormatter.sharedFormatter.string(from: date)
    }
}
