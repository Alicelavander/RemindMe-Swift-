//
//  SettingViewController.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/02/24.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var DataDeleteAllButton: UIButton!
    
    
    func DeleteAll(_ sender: Any) {
        ToDoRepository.shared.removeAllTODO()
        let alert: UIAlertController = UIAlertController(title: "タスク全削除完了", message: "全てのタスクを削除しました。", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dispAlert(sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "タスク全削除", message: "全てのタスクを削除してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.DeleteAll(self)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:nil)
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
