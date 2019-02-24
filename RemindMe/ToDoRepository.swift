//
//  ToDoRepository.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/02/23.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoRepository {
    static let shared = ToDoRepository()
    let realm: Realm
    
    init() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
        })
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm()
    }
    
    func printTODOs() {
        let list = getTODOs()
        print(list)
    }
    
    func getTODOs() -> [ToDoData]{
        return Array(realm.objects(ToDoData.self))
    }
    
    func addTODO(_ addingToDo: ToDoData) {
        try! realm.write{
            realm.add(addingToDo)
        }
    }
    
    func removeTODO(_ deletingToDo: ToDoData) {
        try! realm.write {
            realm.delete(deletingToDo)
        }
    }
    
    func removeAllTODO(){
        try! realm.write {
            realm.deleteAll()
        }
    }

}
