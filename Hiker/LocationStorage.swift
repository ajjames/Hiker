//
//  LocationStorage.swift
//  Hiker
//
//  Created by Andrew James on 8/2/18.
//  Copyright © 2018 aj. All rights reserved.
//

import Foundation
import MapKit
import CoreData

struct Persistence {
    
    struct LocationStorage {
        
        func fetchLocations() -> [CLLocation] {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLocation")
            request.returnsObjectsAsFaults = false
            do {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
                let result = try context.fetch(request)
                let userLocations = (result as? [UserLocation]) ?? []
                let locations = userLocations.map { location -> CLLocation in
                    return CLLocation(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long),
                                      altitude: location.altitude,
                                      horizontalAccuracy: location.horizontalAccuracy,
                                      verticalAccuracy: location.verticalAccuracy,
                                      timestamp: location.timestamp! as Date)
                }
                return locations
            } catch {
                return []
            }
        }
        
        func save(_ locations: [CLLocation]) {
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            DispatchQueue.global().async {
                let context = appDelegate.persistentContainer.newBackgroundContext()
                let entity = NSEntityDescription.entity(forEntityName: "UserLocation", in: context)
                
                for location in locations {
                    let newUserLocation = NSManagedObject(entity: entity!, insertInto: context)
                    self.populate(newUserLocation, with: location)
                }
                appDelegate.saveContext()
            }
        }
        
        private func populate(_ newUserLocation: NSManagedObject, with location: CLLocation) {
            newUserLocation.setValue(location.coordinate.latitude , forKey:  "lat")
            newUserLocation.setValue(location.coordinate.longitude , forKey: "long")
            newUserLocation.setValue(location.timestamp , forKey: "timestamp")
            newUserLocation.setValue(location.altitude , forKey: "altitude")
            newUserLocation.setValue(location.horizontalAccuracy , forKey: "horizontalAccuracy")
            newUserLocation.setValue(location.verticalAccuracy , forKey: "verticalAccuracy")
        }
    }
}
