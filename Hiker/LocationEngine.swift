//
//  LocationEngine.swift
//  Hiker
//
//  Created by Andrew James on 8/2/18.
//  Copyright © 2018 aj. All rights reserved.
//

import Foundation
import MapKit

class LocationEngine: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationEngine()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = 100.0
        return manager
    }()
    
    lazy var locationStorage: Persistence.LocationStorage = Persistence.LocationStorage()
    
    private override init() { }
    
    func clearAllLocations() {
        locationStorage.clearAllLocations()
    }
    
    func startUpdatingLocation() {
        requestAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func storedLocations() -> [UserLocation] {
        return locationStorage.fetchLocations()
    }
    
    private func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Persistence.LocationStorage().save(locations)
    }
}
