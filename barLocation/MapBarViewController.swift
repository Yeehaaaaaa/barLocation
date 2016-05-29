//
//  MapBarViewController.swift
//  barLocation
//
//  Created by Arthur Daurel on 29/05/16.
//  Copyright © 2016 Arthur Daurel. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapBarViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var toPassData: Bars?
    
    let regionRadius: CLLocationDistance = 1000
    var manager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barLocation = CLLocation(latitude: toPassData!.latitude, longitude: toPassData!.longitude)

        self.navigationItem.title = toPassData?.name
        userCurrentLocation()
        pinBars()
        centerMapOnLocation(barLocation)
        
    }
    
    func userCurrentLocation() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }
    
    func pinBars() {
        let mapLocation = MapLocation(title: (toPassData?.name)!,
                                      address: (toPassData?.address)!,
                                      coordinate: CLLocationCoordinate2D(latitude: (toPassData?.latitude)!, longitude: (toPassData?.longitude)!))
        
        mapView.addAnnotation(mapLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}