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

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var zoomIn: UIButton!
    @IBOutlet weak var zoomOut: UIButton!
    @IBOutlet weak var estimatedTime: UILabel!
    
    
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    var lat: CLLocationDegrees??
    var lon: CLLocationDegrees??
    var mUserLocation:CLLocation?
    
    var favouritePlaces: [FavouritePlace]?
      var favoriteAddress: String?
      var favLocation: CLLocation?
      let defaults = UserDefaults.standard
    
    let annotation = MKPointAnnotation()
    let request = MKDirections.Request()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        
     //   loadPins()
        
        self.mapView.showsUserLocation = true // blue dot
        mapView.isZoomEnabled = false
        segmentedControl.isHidden = true
        
        determineCurrentLocation()
        addDoubleTap()
        removePin()
        loadData()
    
        
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
        lat = annotation.coordinate.latitude
        lon = annotation.coordinate.longitude
        annotation.title = "Add To Favourites"
        mapView.addAnnotation(annotation)
        
        
       }
    
    func getDataFilePath() -> String
    {
        //Getting path to txt file
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documentPath.appending("/places-data.txt")
        return filePath
    }
        
    
    func removePin(){
        mapView.removeAnnotation(annotation)
        
    }
    
    @IBAction func transportChange(_ sender: Any) {
        
        routeFinder()
    }
    
    @IBAction func zoomIn(_ sender: UIButton) {
        
        var region: MKCoordinateRegion = mapView.region
             region.span.latitudeDelta /= 2.0
             region.span.longitudeDelta /= 2.0
             mapView.setRegion(region, animated: true)
        
    }
    @IBAction func zoomOut(_ sender: UIButton) {
        
        var region: MKCoordinateRegion = mapView.region
                   region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
                   region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
                   mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func currentLocation(_ sender: UIButton) {
        
            routeFinder()
        
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
    
    func routeFinder()
    {
        self.mapView.removeOverlays(self.mapView.overlays)
        
        if(mUserLocation?.coordinate.longitude == nil || mUserLocation?.coordinate.latitude == nil)
               {
                       let alertController = UIAlertController(title: "Error", message:
                       "Please enable location services in settings", preferredStyle: .alert)
                       alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                       self.present(alertController, animated: true, completion: nil)
                       return
               }
        
         request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (mUserLocation?.coordinate.latitude)!, longitude: (mUserLocation?.coordinate.longitude)!), addressDictionary: nil))
        
        if(lat == nil || lon == nil)
              {
                      let alertController = UIAlertController(title: "Error", message:
                      "No destination selected", preferredStyle: .alert)
                      alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                      self.present(alertController, animated: true, completion: nil)
              }
        else
        {
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), addressDictionary: nil))
        
              request.requestsAlternateRoutes = false
              segmentedControl.isHidden = false
        
        }
        
        // Transport Selection
        switch segmentedControl.selectedSegmentIndex
           {
           case 0:
                request.transportType = .walking
           case 1:
                request.transportType = .automobile
           default:
               break
           }

              let directions = MKDirections(request: request)

              directions.calculate { [unowned self] response, error in
                  guard let unwrappedResponse = response else { return }

                  for route in unwrappedResponse.routes {
                      self.mapView.addOverlay(route.polyline)
                      self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                            
                        }
                    }
                  }
        
    
    
    // Adding Overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3
        return renderer
    }
        

    
    func getFavLocation()
       {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lat!!, longitude: lon!!)) {  placemark, error in
         if let error = error as? CLError
         {
             print("CLError:", error)
             return
         }
         else if let placemark = placemark?[0]
         {
          
          var name = ""
          var city = ""
          var postalCode = ""
          var country = ""
          
          if let name_p = placemark.name { name += name_p }
          if let locality = placemark.subLocality { city += locality }
          if let code = placemark.postalCode { postalCode += code }
          if let country_pc = placemark.country { country += country_pc }

            let place = FavouritePlace(name: name, city: city, postalCode: postalCode, country: country, latitude: self.lat!!, longitude:self.lon!!)
        
          self.favouritePlaces?.append(place)
           self.saveData()
          self.navigationController?.popToRootViewController(animated: true)
               }
           }
    }
    
    func saveData()
    {
        let filePath = getDataFilePath()
        var saveString = ""
        for place in favouritePlaces!
        {
            saveString = "\(saveString)\(place.latitude),\(place.longitude),\(place.name),\(place.city),\(place.country),\(place.postalCode)\n"
                 do
                 {
                    try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
                 }
                 catch
                 {
                     print(error)
                 }
        }
    }
    
      func loadData()
            {
                favouritePlaces = [FavouritePlace]()
                    
                let filePath = getDataFilePath()
                    
                if FileManager.default.fileExists(atPath: filePath)
                {
                    do
                      {
                        //Reading content from file path string
                         let fileContent = try String(contentsOfFile: filePath)
                         let contentArray = fileContent.components(separatedBy: "\n")
                         for content in contentArray
                         {
                               
                            let placeContent = content.components(separatedBy: ",")
                            if placeContent.count == 6
                                {
                                    let place = FavouritePlace(name: placeContent[2], city: placeContent[3], postalCode: placeContent[4], country: placeContent[5],latitude: Double(placeContent[0]) ?? 0.0, longitude: Double(placeContent[1]) ?? 0.0)
                                    favouritePlaces?.append(place)
                                }
                         }
                      }
                        catch
                        {
                            print(error)
                        }
                 }
             }
                
            override func prepare(for segue: UIStoryboardSegue, sender: Any?)
            {
                if let sbPlacesList = segue.destination as?
                    FavouriteListTableViewController{
                sbPlacesList.places = self.favouritePlaces
            }
    }
                

    
    
}
