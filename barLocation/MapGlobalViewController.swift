//
//  MapViewController.swift
//  barLocation
//
//  Created by Arthur Daurel on 27/05/16.
//  Copyright © 2016 Arthur Daurel. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftyJSON

class MapGlobalViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let initialLocation = CLLocation(latitude: 48.8566, longitude: 2.3522)
    let regionRadius: CLLocationDistance = 3000
    
    var manager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCurrentLocation()
        centerMapOnLocation(initialLocation)
        pinBars()
    }
    
    func userCurrentLocation() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }
    
    func pinBars() {
        let path = NSBundle.mainBundle().pathForResource("Pensebete", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        let json = JSON(data: jsonData!)
        let bars = json["bars"]
        var name: String?
        var address: String?
        var latitude: Double?
        var longitude: Double?

        for (_, subJson) in bars {

            if let tmp = subJson["name"].string {
                name = tmp
            }
            if let tmp = subJson["address"].string {
                address = tmp
            }
            if let tmp = subJson["latitude"].double {
                latitude = tmp
            }
            if let tmp = subJson["longitude"].double {
                longitude = tmp
            }
            let mapLocation = MapLocation(title: name!,
                                          address: address!,
                                          coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
            
            mapView.addAnnotation(mapLocation)
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}