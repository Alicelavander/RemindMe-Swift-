//
//  AddToDoController.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/01/02.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit
import RealmSwift

class AddToDoController: UIViewController {
    var Data: Dictionary = [String:String]()
    var lat = ""
    var lng = ""
    var regLat = ""
    var regLng = ""
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var lngTextField: UITextField!
    @IBOutlet weak var ToDoTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var RedButton: UIButton!
    @IBOutlet weak var YellowButton: UIButton!
    @IBOutlet weak var GreenButton: UIButton!
    @IBOutlet weak var BlueButton: UIButton!
    var selectedColor:Int = 0
    @IBOutlet weak var RegButton: UIButton!
    
    @IBAction func colorTag(_ sender: UIButton){
        switch selectedColor{
        case RedButton.tag:
            RedButton.layer.borderColor = UIColor.white.cgColor
            break
            
        case BlueButton.tag:
            BlueButton.layer.borderColor = UIColor.white.cgColor
            break
            
        case GreenButton.tag:
            GreenButton.layer.borderColor = UIColor.white.cgColor
            break
            
        case YellowButton.tag:
            YellowButton.layer.borderColor = UIColor.white.cgColor
            break
            
        default:
            break
        }
        
        switch sender.tag {
        case RedButton.tag:
            RedButton.layer.borderColor = UIColor.black.cgColor
            break
            
        case BlueButton.tag:
            BlueButton.layer.borderColor = UIColor.black.cgColor
            break
            
        case GreenButton.tag:
            GreenButton.layer.borderColor = UIColor.black.cgColor
            break
            
        case YellowButton.tag:
            YellowButton.layer.borderColor = UIColor.black.cgColor
            break
            
        default:
            break
        }
        
        selectedColor = sender.tag
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(regLat, regLng)
        ToDoTextField.addTarget(self, action: #selector(ToDotextFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapView" {
            print("Current location at AddToDo:",lat, lng)
            let mapViewController:MapViewController = segue.destination as! MapViewController
            mapViewController.latitude = String("\(lat)")
            mapViewController.longitude = String("\(lng)")
        }
    }
}

