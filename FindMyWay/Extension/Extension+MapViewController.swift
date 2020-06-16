//
//  File.swift
//  FindMyWay
//
//  Created by Kritima Kukreja on 2020-06-16.
//  Copyright © 2020 Kritima Kukreja. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate {
    
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
        {
            if annotation is MKUserLocation
            {
                return nil
            }
            
            
            let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
            pinAnnotation.pinTintColor = UIColor.red
            pinAnnotation.canShowCallout = true
            
            //Adding custom button
            let mapsButton = UIButton()
            mapsButton.setImage(UIImage(named :"star"), for: .normal)
            mapsButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            pinAnnotation.rightCalloutAccessoryView = mapsButton
            
            return pinAnnotation
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
        {
            let alertController = UIAlertController(title: "Add to Favourites", message:
                        "Do you want to add to favourites?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style:  .default, handler: { (UIAlertAction) in
            self.getFavLocation() }))
                
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
        }
}
