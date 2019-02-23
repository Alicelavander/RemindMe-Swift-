//
//  DetailViewController.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/02/23.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var Detailfield: UILabel!
    @IBOutlet weak var Background: UIView!
    
    var todo = ToDoData()
    
    @IBOutlet weak var ggg: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.title = todo.ToDo
        ggg.title = todo.ToDo
        Detailfield.text = todo.detail
        Background.backgroundColor = todo.uiColor
        
    }
    
    func DisplayColor(){
        
    }
}
