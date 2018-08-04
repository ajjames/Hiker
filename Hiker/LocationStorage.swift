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
        
        func fetchLocations() -> [UserLocation] {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLocation")
            request.returnsObjectsAsFaults = false
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
            let result = try! context.fetch(request)
            return (result as! [UserLocation])
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
                try? context.save()
            }
        }
        
        func clearAllLocations() {
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            DispatchQueue.global().async {
                let context = appDelegate.persistentContainer.newBackgroundContext()
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLocation")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                _ = try? context.execute(deleteRequest)
                try? context.save()
            }
        }
        
        private func populate(_ newUserLocation: NSManagedObject, with location: CLLocation) {
            newUserLocation.setValue(location.coordinate.latitude , forKey:  "lat")
            newUserLocation.setValue(location.coordinate.longitude , forKey: "long")
            newUserLocation.setValue(location.timestamp , forKey: "timestamp")
        }
    }
}
