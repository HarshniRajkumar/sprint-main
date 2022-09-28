//
//  MapViewController.swift
//  sprint2
//
//  Created by Capgemini-DA088 on 9/24/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
   //outlet connection given:
    
    @IBOutlet weak var mapView: MKMapView!
    
    
   //declaring variables:
    var locationmanager : CLLocationManager!
    var currentLoc = "Current Location"
    var mUserLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //calling func in viewdidappear
    override func viewDidAppear(_ animated: Bool)
        {
           determineUserLocation()
        }
    //func to determine the location of user
    func determineUserLocation(){
        //locationmanager is initated and assigned
        locationmanager = CLLocationManager()
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestAlwaysAuthorization()
        
        //to update the location as the user moves:
        if CLLocationManager.locationServicesEnabled(){
            locationmanager.startUpdatingLocation()
        }
}
    //func to get the address
    func getAddress(handler: @escaping (String)-> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: mUserLocation.coordinate.latitude,
                                  longitude: mUserLocation.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks,error)->Void in
            var placemark: CLPlacemark?
            //placemark is used and a proper location of the user is obtained exactly with location details
            placemark = placemarks?[0]
            
            let address = "\(placemark?.subThoroughfare ?? ""), \(placemark?.thoroughfare ?? ""),\(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""),\(placemark?.postalCode ?? ""),\(placemark?.country ?? "")"
            self.currentLoc = address
            print("\(address)")
            handler(address)
        })
        
    }
}
//extension incorporated:
extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let mUserLoc: CLLocation = locations[0] as CLLocation
        //latitude and longitude of the location
        let center = CLLocationCoordinate2D(latitude: mUserLoc.coordinate.latitude, longitude: mUserLoc.coordinate.longitude)
        //set the correct location
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        //to provide that required annotation for the location to be viewed accurately:
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        getAddress{(address)in
            annotation.title = address
        }
        self.mapView.addAnnotation(annotation)
    }
 //locationm manager is used to manage errors:
    func locationManager(_manager: CLLocationManager, didFailWithErrror error: Error){
        print("Manager Error\(error.localizedDescription)")
    }
    }


