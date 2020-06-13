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
import Contacts

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
       var currentLocationStr = "Current location"
    
    var mUserLocation:CLLocation?
    let annotation = MKPointAnnotation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        self.mapView.showsUserLocation = true // blue dot
        mapView.isZoomEnabled = false
        determineCurrentLocation()
        
       addDoubleTap()
        
    }
    
    func addDoubleTap()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
               tap.numberOfTapsRequired = 2
               mapView.addGestureRecognizer(tap)
    }
    
    @objc func doubleTapped(sender: UITapGestureRecognizer) {
    
    let locationInView = sender.location(in: mapView)
    let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
    addAnnotation(coordinate: tappedCoordinate)
    }
    
    func addAnnotation(coordinate:CLLocationCoordinate2D){
       annotation.coordinate = coordinate
       mapView.addAnnotation(annotation)
       }
    
    
    @IBAction func routeLocation(_ sender: UIButton) {
        
       let request = MKDirections.Request()
        
              request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: mUserLocation!.coordinate.latitude, longitude: mUserLocation!.coordinate.longitude), addressDictionary: nil))
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), addressDictionary: nil))
        
              request.requestsAlternateRoutes = false
              request.transportType = .automobile

              let directions = MKDirections(request: request)

              directions.calculate { [unowned self] response, error in
                  guard let unwrappedResponse = response else { return }

                  for route in unwrappedResponse.routes {
                      self.mapView.addOverlay(route.polyline)
                      self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                  }
              }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             mUserLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation!.coordinate.latitude, longitude: mUserLocation!.coordinate.longitude)
        
            let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    

            mapView.setRegion(mRegion, animated: true)
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
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
    

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
}
