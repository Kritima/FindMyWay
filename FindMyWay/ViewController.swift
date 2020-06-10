//
//  ViewController.swift
//  FindMyWay
//
//  Created by Kritima Kukreja on 2020-06-08.
//  Copyright © 2020 Kritima Kukreja. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.centerToLocation(initialLocation)
    }


}

private extension MKMapView {
func centerToLocation(
  _ location: CLLocation,
  regionRadius: CLLocationDistance = 1000
) {
  let coordinateRegion = MKCoordinateRegion(
    center: location.coordinate,
    latitudinalMeters: regionRadius,
    longitudinalMeters: regionRadius)
  setRegion(coordinateRegion, animated: true)
}
}

