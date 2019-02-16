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
    var locationManager: CLLocationManager!
    var CurrentLatitude = 0.0
    var CurrentLongitude = 0.0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Here: CLLocation = CLLocation(latitude: CurrentLatitude, longitude: CurrentLongitude)
        let There: CLLocation = CLLocation(latitude: Double(list[indexPath.row].lat) ?? 0.0, longitude: Double(list[indexPath.row].lng) ?? 0.0)
        let Distance = There.distance(from: Here)
        print(Distance)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        let Todo = list[indexPath.row].ToDo.filter({_ in Distance < 100})
        cell.ToDo.text = Todo
        switch list[indexPath.row].Color {
        case 1:
            cell.Color.tintColor = UIColor(red: 246, green: 71, blue: 71, alpha: 1.0)
            break
            
        case 2:
            cell.Color.backgroundColor = UIColor(red: 243, green: 156, blue: 18, alpha: 1.0)
            break
            
        case 3:
            cell.Color.backgroundColor = UIColor(red: 25, green: 181, blue: 254, alpha: 1.0)
            break
            
        case 4:
            cell.Color.backgroundColor = UIColor(red: 135, green: 211, blue: 124, alpha: 1.0)
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
            
           // print(list)
            let data = addToDoController.Data
            let newToDo = ToDoData()
			newToDo.Id = UUID().uuidString //固有のIDを作り削除機能の際に用いる
            newToDo.ToDo = data["ToDo"] ?? ""
            newToDo.lat = data["lat"] ?? ""
            newToDo.lng = data["lng"] ?? ""
            newToDo.detail = data["detail"] ?? ""
            newToDo.Color = Int(data["Color"] ?? "0") ?? 0
            list.append(newToDo)
            print(list)
            Table.reloadData()
            do{
                let realm = try Realm()
                try! realm.write{
                    realm.add(newToDo)
                }
            }catch{
                
            }
        }
    }
    
    func getData(){
        do{
            let realm = try Realm()
            list = Array(realm.objects(ToDoData.self))
            Table.reloadData()
        }catch{
            
        }
    }
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

