//
//  ToDoData.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/02/08.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoData: Object{
    @objc dynamic public var ToDo:String = ""
    @objc dynamic public var lat:String = ""
    @objc dynamic public var lng:String = ""
    @objc dynamic public var detail:String = ""
    @objc dynamic public var Color:Int = 0
}
