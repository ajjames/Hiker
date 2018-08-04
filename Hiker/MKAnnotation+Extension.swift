//
//  MKAnnotation+Extension.swift
//  Hiker
//
//  Created by Andrew James on 8/3/18.
//  Copyright © 2018 aj. All rights reserved.
//

import Foundation
import MapKit

extension MKAnnotation {
    
    func detail(completion: @escaping (String?)->() ) {
        var result = "Lat:  \(self.coordinate.latitude)\nLong: \(self.coordinate.longitude)\n"
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)) { placemarks, error in
            guard error == nil else {
                result.append("\nError: \(String(describing: error))")
                completion(nil)
                return
            }
            let placemarks = placemarks ?? []
            
            for placemark in placemarks {
                let name = placemark.name ?? ""
                let thoroughfare = placemark.thoroughfare ?? ""
                let subThoroughfare = placemark.subThoroughfare ?? ""
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let postalCode = placemark.postalCode ?? ""
                let country = placemark.country ?? ""
                
                result.append("\n")
                result.append("\nname: \(name)")
                result.append("\naddress1: \(thoroughfare)")
                result.append("\naddress2: \(subThoroughfare)")
                result.append("\ncity: \(locality)")
                result.append("\nstate: \(administrativeArea)")
                result.append("\nzip code: \(postalCode)")
                result.append("\ncountry: \(country)")
                result.append("\nareasOfInterest: ")
                if let areasOfInterest = placemark.areasOfInterest {
                    for areasOfInterest in areasOfInterest {
                        result.append("\n   \(areasOfInterest)")
                    }
                }
            }
            guard !result.isEmpty else {
                completion("\nUnable to locate nearby placemarks")
                return
            }
            completion(result)
            return
        }
    }
}
