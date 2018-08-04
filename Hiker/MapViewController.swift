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
    private let zoomLevel: Double = 0.003
    private let fullMapHeight: CGFloat = 1
    private let collapsedMapHeight: CGFloat = 0.3
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var gpsLocationButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    lazy var locationEngine: LocationEngine = .shared
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationEngine.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !locationEngine.locationServicesEnabled() {
            showTrackingAlert()
        }
        clearMap()
        loadFullHistory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - private
    
    private func listenForNewData() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidUpdate(_:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc private func dataDidUpdate(_ notification: Notification) {
        let uniqueLocations = notification.userInfo?["inserted"] as? Set<UserLocation>
        guard let locations = uniqueLocations?.map({$0}) else {
            return
        }
        DispatchQueue.main.async { [unowned self] in
            _ = self.addAnnotations(for: locations)
        }
    }
    
    private func clearMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
    
    private func loadFullHistory() {
        let locations = locationEngine.storedLocations()
        let annotations = addAnnotations(for: locations)
        if annotations.count > 1 {
            mapView.showAnnotations(annotations, animated: false)
        } else if locations.count == 0 {
            enableFollowMode()
        }
        listenForNewData()
    }
    
    private func addAnnotations(for locations: [UserLocation]) -> [MKAnnotation] {
        let annotations = locations.map { location -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.title
            return annotation
        }
        mapView.addAnnotations(annotations)
        return annotations
    }
    
    private func zoomTo(_ coordinate: CLLocationCoordinate2D) {
        let delta = CLLocationDegrees(zoomLevel)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)), animated: false)
    }
    
    private func showDetailFor(_ annotation: MKAnnotation) {
        disableFollowMode()
        gpsLocationButton.isEnabled = false
        settingsButton.isEnabled = false
        self.detailText.isHidden = false
        self.zoomTo(annotation.coordinate)
        annotation.detail() { [unowned self] text in
            self.detailText.text = text
        }
    }
    
    private func hideDetailFor(_ annotation: MKAnnotation) {
        gpsLocationButton.isEnabled = true
        settingsButton.isEnabled = true
        self.detailText.isHidden = true
        self.detailText.text = nil
    }
    
    private func showTrackingAlert() {
        let alertViewController = UIAlertController(title: "GPS Warning", message: "Unable to access tracking data. Please make sure location services are always enabled for this app.", preferredStyle: .alert)
        present(alertViewController, animated: true, completion: nil)
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        showDetailFor(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        hideDetailFor(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // MARK: - IBAction
    
    @IBAction func didTapGpsMarkerButton(_ sender: Any) {
        switch mapView.userTrackingMode {
        case .follow:
            disableFollowMode()
        default:
            enableFollowMode()
        }
    }
    
    private func disableFollowMode() {
        mapView.userTrackingMode = .none
        gpsLocationButton.image = #imageLiteral(resourceName: "gps_marker")
    }
    
    private func enableFollowMode() {
        mapView.userTrackingMode = .follow
        gpsLocationButton.image = #imageLiteral(resourceName: "gps_marker_filled")
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToMap(_ sender: UIStoryboardSegue) {}
}
