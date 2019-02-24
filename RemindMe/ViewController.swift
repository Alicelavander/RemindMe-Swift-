//
//  ViewController.swift
//  RemindMe
//
//  Created by Alicelavander on 2018/12/21.
//  Copyright © 2018年 Alicelavander. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate{
    @IBOutlet var Table:UITableView!
    //var list:Array<ToDoData> = Array()
    var listHere:Array<ToDoData> = Array()
    var locationManager: CLLocationManager!
    let notificationManager: NotificationManager = NotificationManager.init()
    var CurrentLatitude = 0.0
    var CurrentLongitude = 0.0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return listHere.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // セルの上部のスペース
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listHere.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ToDo = listHere[indexPath.section]
            listHere.remove(at: indexPath.section)
            ToDoRepository.shared.removeTODO(ToDo)
            showFilteredList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = listHere[indexPath.section]
        performSegue(withIdentifier: "ShowDetail", sender: todo)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        let Todo = listHere[indexPath.section]
        cell.ToDo.text = Todo.ToDo
        cell.Color.backgroundColor = Todo.uiColor
        
        let layer = cell.layer
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        return cell;
    }
    
    @IBAction func unwindToListToDo(sender: UIStoryboardSegue){
        if sender.identifier == "BackToView" {
            let addToDoController:AddToDoController = sender.source as! AddToDoController
            addToDoController.Data["lat"] = addToDoController.latTextField.text
            addToDoController.Data["lng"] = addToDoController.lngTextField.text
            addToDoController.Data["detail"] = addToDoController.detailTextField.text
            addToDoController.Data["Color"] = String(addToDoController.selectedColor)
            
            let data = addToDoController.Data
            let newToDo = ToDoData()
            newToDo.ToDo = data["ToDo"] ?? ""
            newToDo.lat = Double(data["lat"] ?? "") ?? 0.0
            newToDo.lng = Double(data["lng"] ?? "") ?? 0.0
            newToDo.detail = data["detail"] ?? ""
            newToDo.Color = Int(data["Color"] ?? "0") ?? 0
            
            ToDoRepository.shared.addTODO(newToDo)
            
            ToDoRepository.shared.printTODOs()
            
            showFilteredList()
            
            let reglat: Double = newToDo.lat
            let reglng: Double = newToDo.lng
            addNewLocalNotification(lat: reglat, lng: reglng, distance: 100)
        }else if sender.identifier == "EndDetail"{
            // empty
        }else if sender.identifier == "EndSettings"{
            //empty
        }
    }
    
    func showFilteredList(){
        listHere.removeAll()
        
        let list = ToDoRepository.shared.getTODOs()
        for item in list {
            let Here: CLLocation = CLLocation(latitude: CurrentLatitude, longitude: CurrentLongitude)
            let There: CLLocation = CLLocation(latitude: item.lat, longitude: item.lng)
            let Distance = There.distance(from: Here)
            print(Distance)
            if Distance < 100 {
                listHere.append(item)
            }
        }
        Table.reloadData()
    }
    
/////ここからLocation & Basic stuff/////
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.authorizedAlways {
            return
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        startLocationService(manager: manager)
    }
    
    func checkLocationAuthorization(callback: (CLLocationManager) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied {
            return
        }
        
        locationManager.delegate = self
        
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if !CLLocationManager.locationServicesEnabled() {
            return
        } else {
            callback(locationManager)
        }
    }
    
    func startLocationService(manager: CLLocationManager) {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
    }
    
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
        showFilteredList()
        print("Current Location at ViewController",CurrentLatitude,",",CurrentLongitude)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddToDo" {
            let addTodoController:AddToDoController = segue.destination as! AddToDoController
            addTodoController.lat = String("\(CurrentLatitude)")
            addTodoController.lng = String("\(CurrentLongitude)")
        } else if segue.identifier == "ShowDetail" {
            let detailViewController:DetailViewController = segue.destination as! DetailViewController
            detailViewController.todo = sender as! ToDoData
        }
    }
    
    override func viewDidLoad() {
        print("app started")
        myLocationManagerSetup()
        checkLocationAuthorization(callback: startLocationService)
        ToDoRepository.shared.printTODOs()
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        Table.register(nib, forCellReuseIdentifier: "myCell")
        Table.delegate = self
        Table.dataSource = self
        super.viewDidLoad()
        showFilteredList()
        
    }

    func addNewLocalNotification(lat: Double, lng:Double, distance: Double){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "RemindingYou"
        content.body = "ここら辺でやることがあります！"
        content.sound = UNNotificationSound.default
        
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        let region = CLCircularRegion.init(center: coordinate, radius: distance, identifier: "Notification")
        region.notifyOnEntry = true;
        region.notifyOnExit = true;
        let trigger = UNLocationNotificationTrigger.init(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        center.add(request)
        center.delegate = self
    }
}

