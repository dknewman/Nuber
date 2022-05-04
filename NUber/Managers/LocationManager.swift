//
//  LocationManager.swift
//  NUber
//
//  Created by David Newman on 4/20/22.
//

import Foundation
import CoreLocation
import UIKit

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
        
        guard let firstLocation = locations.first else {return}
        
        if CLLocationCoordinate2DIsValid(firstLocation.coordinate){
            currentLocation = .init(location: firstLocation)
            if let update = locationUpdated{
                update()
            }
            
        }
    }
    
    func locationManager (_ manager: CLLocationManager,
                                     didChangeAuthorization status: CLAuthorizationStatus) {   switch status {
    case .restricted, .denied:
        // Disable your app's location features
        print("You have denied Nubers location permissions. Please go to settings to allow it ")
        
        break
        
    case .authorizedWhenInUse:
        // Enable your app's location features.
        break
        
    case .authorizedAlways:
        // Enable or prepare your app's location features that can run any time.
        break
        
    case .notDetermined:
        break
    @unknown default:
        
        print("Error")
        
        }
        
    }
    
}


