//
//  LocationManager.swift
//  NUber
//
//  Created by David Newman on 4/20/22.
//

import Foundation
import CoreLocation

typealias handler = () -> ()?

class LocationManager: NSObject {
   
    public static let shared = LocationManager()
    
    var locationUpdated: handler?
    
    var currentLocation: LocationAddress?
    
    private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        
        return locationManager
        
    }()
    
    func startLocationUpdate(completed: handler?){
        locationUpdated = completed
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let lastLocation = locations.last {
//            print("Lat : \(lastLocation.coordinate.latitude) \nLng : \(lastLocation.coordinate.longitude)")
//        }
        guard let firstLocation = locations.first else {return}
        
        if CLLocationCoordinate2DIsValid(firstLocation.coordinate){
            currentLocation = .init(location: firstLocation)
            if let update = locationUpdated{
                update()
            }
            
        }
    }
    
}


