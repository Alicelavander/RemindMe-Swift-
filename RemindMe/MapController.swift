//
//  MapController.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/01/30.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Foundation

class MapController: UIViewController, GMSMapViewDelegate{
    var delegate:MapConnection? = nil
    var marker = GMSMarker()
    var latitude = ""
    var longitude = ""
    var reglat = 0.0
    var reglng = 0.0
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        mapView.clear()
        marker = GMSMarker(position: coordinate)
        reglat = coordinate.latitude
        reglng = coordinate.longitude
        marker.map = mapView
        
        delegate?.Currentlatlng(lat: reglat, lng: reglng)
    }
    
    override func loadView() {
        print("CurrentLocation:"+latitude+",",longitude)
        let camera = GMSCameraPosition.camera(withLatitude: Double(latitude)!, longitude: Double(longitude)!, zoom: 15.0)
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.isMyLocationEnabled = true
        view = map
        map.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapView" {
            let mapViewController = segue.destination as! MapViewController
            mapViewController.latitude = String("\(latitude)")
            mapViewController.longitude = String("\(latitude)")
        }
    }
}
