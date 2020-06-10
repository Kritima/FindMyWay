//
//  ViewController.swift
//  FindMyWay
//
//  Created by Kritima Kukreja on 2020-06-08.
//  Copyright © 2020 Kritima Kukreja. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
       var currentLocationStr = "Current location"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let mUserLocation:CLLocation = locations[0] as CLLocation

            let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
            let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mapView.setRegion(mRegion, animated: true)
        }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }
    
    func showOnMap(location: CLLocation )
       {
           let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
           let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
           mapView.setRegion(region, animated: true)
       }


func determineCurrentLocation() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()

    if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
    }
}
}
