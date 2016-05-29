//
//  MapLocation.swift
//  barLocation
//
//  Created by Arthur Daurel on 27/05/16.
//  Copyright © 2016 Arthur Daurel. All rights reserved.
//

import Foundation
import MapKit

class MapLocation: NSObject, MKAnnotation {
    
    let title: String?
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.address = address
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
}
