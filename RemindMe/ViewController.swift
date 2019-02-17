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

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var Table:UITableView!
    var list:Array<ToDoData> = Array()
    var listHere:Array<ToDoData> = Array()
    var locationManager: CLLocationManager!
    let notificationManager: Notification = Notification.init()
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
    
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: IndexPath) -> Bool
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
            
            startLocationService(manager: locationManager)
        }
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

    func startLocationService(manager: CLLocationManager) {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
    }
    
    func registerLocationBasedLocalNotification(latitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: CLLocationDistance) {
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let region = CLCircularRegion.init(center: center, radius: radius, identifier: "YourLocationIdentifier")
        region.notifyOnExit = false
        notificationManager.setLocationBasedLocalNotification(region: region, alertAction: "Alert Action", alertBody: "あいうえお", soundName: UILocalNotificationDefaultSoundName)
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
    }

}

