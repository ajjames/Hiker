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
        return manager
    }()
    
    lazy var locationStorage: Persistence.LocationStorage = Persistence.LocationStorage()
    
    private override init() { }

    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func significantLocationChangeMonitoringAvailable() -> Bool {
        return CLLocationManager.significantLocationChangeMonitoringAvailable()
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Persistence.LocationStorage().save(locations)
    }
}
