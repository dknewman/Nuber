//
//  ViewController.swift
//  NUber
//
//  Created by David Newman on 4/19/22.
//

import UIKit
import MapKit
import FloatingPanel

class MapViewController: UIViewController {
   
    var fpc: FloatingPanelController!

    private let map: MKMapView = {
        let map = MKMapView()
        map.mapType = MKMapType.standard
        return map
    }()
    
    private let annotation: MKPointAnnotation = {
        let anno = MKPointAnnotation()
        anno.title = "You Are Here!"
        anno.subtitle = "current location"
        return anno
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(map)
        
        DispatchQueue.main.async {
            self.map.addAnnotation(self.annotation)
            self.setUpFloatingPanel()

        }
        
        LocationManager.shared.startLocationUpdate{ () -> ()? in
            self.getLocation()
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    func getLocation() {
        if let currentLocation = LocationManager.shared.currentLocation{
            let coordinate = currentLocation.location.coordinate
            annotation.coordinate = currentLocation.location.coordinate
            
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            DispatchQueue.main.async {
                self.map.setRegion(region, animated: true)
            }
            #if DEBUG
            print("Latitude: \(coordinate.latitude) \nLongitude: \(coordinate.longitude)")
            #endif
        }
    }
    
    func setUpFloatingPanel(){
        
        fpc = FloatingPanelController()
        let SearchVC = SearchViewController()
        fpc.set(contentViewController: SearchVC)
        fpc.addPanel(toParent: self)
        fpc.contentMode = .fitToBounds
        fpc.layout = MyFloatingPanelLayout()
        fpc.move(to: .tip, animated: false)
    }
}
