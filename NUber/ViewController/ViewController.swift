//
//  ViewController.swift
//  NUber
//
//  Created by David Newman on 4/19/22.
//

import UIKit
import MapKit
class ViewController: UIViewController {
    
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        LocationManager.shared.startLocationUpdate{ () -> ()? in
            self.showLocation()
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    func showLocation() {
       if let currentLocation = LocationManager.shared.currentLocation{
           let coordinate = currentLocation.location.coordinate
           print("Latitude: \(coordinate.latitude) \nLongitude: \(coordinate.longitude)")
       }
   }
   
    
}

    
