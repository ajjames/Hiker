//
//  MapViewController.swift
//  Hiker
//
//  Created by Andrew James on 8/2/18.
//  Copyright © 2018 aj. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet var mapView: MKMapView!
    lazy var locationEngine: LocationEngine = .shared
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !locationEngine.significantLocationChangeMonitoringAvailable() {
            print("here!")
        }
        locationEngine.startUpdatingLocation()
        subscribeToNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidUpdate(notification:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc private func dataDidUpdate(notification: Notification) {
        DispatchQueue.main.async { [unowned self] in
            let locations = [CLLocation]()
            self.refreshMap(with: locations)
        }
    }
    
    private func refreshMap(with locations: [CLLocation]) {
        let annotations = locations.map { location -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "\(location.timestamp)"
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        if mapView.showsUserLocation
        {
            let delta = CLLocationDegrees(0.01)
            mapView.setRegion(MKCoordinateRegion(center:mapView.userLocation.coordinate, span:MKCoordinateSpan(latitudeDelta:delta, longitudeDelta:delta)) , animated:true)
        }
    }
    
    // MARK: - Navigation

    @IBAction func unwindToMap(_ sender: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
