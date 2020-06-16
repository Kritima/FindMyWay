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
            //Show nothing if loction is user's location
            if annotation is MKUserLocation
            {
                return nil
            }
            
            //Adding a custom pin
            let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
            pinAnnotation.pinTintColor = UIColor.blue
            pinAnnotation.canShowCallout = true
            
            //Adding custom button
            let button = UIButton()
            button.setImage(UIImage(named :"heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            pinAnnotation.rightCalloutAccessoryView = button
            
            return pinAnnotation
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
        {
            //Alert to confirm user action
            let alertController = UIAlertController(title: "Add to Favourites", message:
                        "Do you want to add to favourites?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style:  .default, handler: { (UIAlertAction) in
            self.getFavLocation() }))
                
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
        }
}
