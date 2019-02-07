//
//  AddToDoController.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/01/02.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit

class AddToDoController: UIViewController {
    var Data: Dictionary = [String:String]()
    var lat = ""
    var lng = ""
    var regLat = ""
    var regLng = ""
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var lngTextField: UITextField!
    @IBOutlet weak var ToDoTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    
    @IBAction func unwindToAddToDo(sender: UIStoryboardSegue){
        if sender.identifier == "BackToAddToDo" {
            let mapViewController = sender.source as! MapViewController
            regLat = String("\(mapViewController.reglat)")
            regLng = String("\(mapViewController.reglng)")
            latTextField.text = regLat
            lngTextField.text = regLng
            print("Selected lat & lng")
        }
    }
    
    @objc func ToDotextFieldDidChange(_ textField: UITextField) {
        Data["ToDo"] = ToDoTextField.text
    }
    
    @objc func lattextFieldDidChange(_ textField: UITextField) {
        Data["lat"] = latTextField.text
    }
    
    @objc func lngtextFieldDidChange(_ textField: UITextField) {
        Data["lng"] = lngTextField.text
    }
    
    @objc func detailtextFieldDidChange(_ textField: UITextField) {
        Data["detail"] = ToDoTextField.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(regLat, regLng)
        ToDoTextField.addTarget(self, action: #selector(ToDotextFieldDidChange(_:)), for: .editingChanged)
        //latTextField.addTarget(self, action: #selector(lattextFieldDidChange(_:)), for: .editingChanged)
        //lngTextField.addTarget(self, action: #selector(lngtextFieldDidChange(_:)), for: .editingChanged)
        //detailTextField.addTarget(self, action: #selector(detailtextFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapView" {
            print("AddTodo location:",lat, lng)
            let mapViewController:MapViewController = segue.destination as! MapViewController
            mapViewController.latitude = String("\(lat)")
            mapViewController.longitude = String("\(lng)")
            
        }else if segue.identifier == "BackToView" {
            Data["lat"] = latTextField.text
            Data["lng"] = lngTextField.text
            Data = [String : String](uniqueKeysWithValues: Data.sorted{ $0.key < $1.key })
            let viewController:ViewController = segue.destination as! ViewController
            viewController.Data = String("\(Data)")
            print(Data)
        }
    }
}
