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

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate{
    @IBOutlet var Table:UITableView!
    var list:Array<ToDoData> = Array()
    var listHere:Array<ToDoData> = Array()
    var locationManager: CLLocationManager!
    let notificationManager: NotificationManager = NotificationManager.init()
    var CurrentLatitude = 0.0
    var CurrentLongitude = 0.0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHere.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        let Todo = listHere[indexPath.row].ToDo
        cell.ToDo.text = Todo
        switch listHere[indexPath.row].Color {
        case 1:
            cell.Color.backgroundColor = UIColor(red: 246/255, green: 71/255, blue: 71/255, alpha: 1.0)
            break
            
        case 2:
            cell.Color.backgroundColor = UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
            break
            
        case 3:
            cell.Color.backgroundColor = UIColor(red: 25/255, green: 181/255, blue: 254/255, alpha: 1.0)
            break
            
        case 4:
            cell.Color.backgroundColor = UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 1.0)
            break
            
        default:
            break
        }
        return cell;
    }
    
    @IBAction func unwindToAddToDo(sender: UIStoryboardSegue){
        if sender.identifier == "BackToView" {
            let addToDoController:AddToDoController = sender.source as! AddToDoController
            addToDoController.Data["lat"] = addToDoController.latTextField.text
            addToDoController.Data["lng"] = addToDoController.lngTextField.text
            addToDoController.Data["detail"] = addToDoController.detailTextField.text
            addToDoController.Data["Color"] = String(addToDoController.selectedColor)
            
            let data = addToDoController.Data
            let newToDo = ToDoData()
            newToDo.ToDo = data["ToDo"] ?? ""
            newToDo.lat = data["lat"] ?? ""
            newToDo.lng = data["lng"] ?? ""
            newToDo.detail = data["detail"] ?? ""
            newToDo.Color = Int(data["Color"] ?? "0") ?? 0
            list.append(newToDo)
            print(list)
            showFilteredList()
            do{
                let realm = try Realm()
                try! realm.write{
                    realm.add(newToDo)
                }
            }catch{
                
            }
        
        }
        let A: CLLocation = CLLocation(latitude: CurrentLatitude, longitude: CurrentLongitude)
        let B: CLLocation = CLLocation(latitude: Data["lat"]  ?? 0.0, longitude: Data["lng"] ?? 0.0)
        let Distance = B.distance(from: A)
        addNewLocalNotification(lat: Data["lat"], lng: Data["lng"], distance: Distance)
    }
    
    func getData(){
        do{
            let realm = try Realm()
            list = Array(realm.objects(ToDoData.self))
            showFilteredList()
            Table.reloadData()
        }catch{
            
        }
    }
    
    func showFilteredList(){
        listHere.removeAll()
        for item in list {
            let Here: CLLocation = CLLocation(latitude: CurrentLatitude, longitude: CurrentLongitude)
            let There: CLLocation = CLLocation(latitude: Double(item.lat) ?? 0.0, longitude: Double(item.lng) ?? 0.0)
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
        print("Current Location at ViewController",CurrentLatitude,",",CurrentLongitude)
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
        print(list)
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        Table.register(nib, forCellReuseIdentifier: "myCell")
        Table.delegate = self
        Table.dataSource = self
        super.viewDidLoad()
        myLocationManagerSetup()
        getData()
        checkLocationAuthorization(callback: startLocationService)
    }

    func addNewLocalNotification(lat: Double, lng:Double, distance: Double){
        let center = NotificationCenter.currentNotificationCenter()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "通知のタイトル" //ここで通知のタイトルを決める
        content.body = "通知の本文" //ここで通知の本文を決める
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

