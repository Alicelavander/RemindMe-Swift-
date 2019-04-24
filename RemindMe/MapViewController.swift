//
//  MapViewController.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/01/02.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Foundation

protocol MapConnection {
    func Currentlatlng(lat: Double, lng: Double)
}

class MapViewController: UIViewController, MapConnection{
    @IBOutlet weak var SearchBar: UITextField!
    @IBOutlet weak var SelectButton: UIButton!
    var latitude = ""
    var longitude = ""
    var reglat = 0.0
    var reglng = 0.0
    
    func Currentlatlng(lat: Double, lng: Double) {
        reglat = lat
        reglng = lng
    }

    
    @IBAction func ButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "BackToAddToDo", sender: self )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedMap" {
            let mapController = segue.destination as! MapController
            mapController.delegate = self
            mapController.latitude = latitude
            mapController.longitude = longitude
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectButton.layer.cornerRadius = 30
        SelectButton.layer.masksToBounds = true
        SelectButton.layer.borderWidth = 1
        SelectButton.layer.borderColor = UIColor.black.cgColor
    }
 }
