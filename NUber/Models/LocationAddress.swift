//
//  File.swift
//  NUber
//
//  Created by David Newman on 4/22/22.
//

import Foundation
import CoreLocation

struct LocationAddress {
    var location: CLLocation
    var city: String?
    var country: String?
    var address: String?
    
    init(location: CLLocation){
        self.location = location
    }
}

