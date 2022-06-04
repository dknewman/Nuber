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
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.backgroundColor = .secondarySystemBackground
        button.setTitle("M", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(map)
        view.addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
        DispatchQueue.main.async {
            self.map.addAnnotation(self.annotation)
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
    
    @objc
    func menuButtonPressed(){
        print("Button Tapped!")
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
    
    func setupLayout(){
        self.setUpFloatingPanel()

        let padding: CGFloat = 10
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: padding),
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 50)

        ])
        
        
    }
}
