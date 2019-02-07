//
//  ViewController.swift
//  RemindMe
//
//  Created by Alicelavander on 2018/12/21.
//  Copyright © 2018年 Alicelavander. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = list[indexPath.row]
        return cell;
    }
    @IBOutlet var Table:UITableView!
    let list = ["a", "b", "c"]
    var Data = ""
    var locationManager: CLLocationManager!
    var CurrentLatitude = 0.0
    var CurrentLongitude = 0.0
    
    
    
/////ここからLocation & Basic stuff/////
    func myLocationManagerSetup() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways{
            print("authorisedAlways")
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }else if status == .authorizedWhenInUse{
            print("authorisedWhenInUse")
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        CurrentLatitude = latitude!
        CurrentLongitude = longitude!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddToDo" {
            let addTodoController:AddToDoController = segue.destination as! AddToDoController
            addTodoController.lat = String("\(CurrentLatitude)")
            addTodoController.lng = String("\(CurrentLongitude)")
        }
    }
 
    override func viewDidLoad() {
        print("app started")
        Table.delegate = self
        Table.dataSource = self
        super.viewDidLoad()
        myLocationManagerSetup()
    }
}
