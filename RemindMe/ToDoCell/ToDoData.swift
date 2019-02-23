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
    @objc dynamic public var lat:Double = 0.0
    @objc dynamic public var lng:Double = 0.0
    @objc dynamic public var detail:String = ""
    @objc dynamic public var Color:Int = 0
}

extension ToDoData{
    var uiColor: UIColor{
        switch self.Color {
        case 1:
            return UIColor(red: 246/255, green: 71/255, blue: 71/255, alpha: 1.0)
        case 2:
            return UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
        case 3:
            return UIColor(red: 25/255, green: 181/255, blue: 254/255, alpha: 1.0)
        case 4:
            return UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 1.0)
        default:
            return UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        }
    }
}
