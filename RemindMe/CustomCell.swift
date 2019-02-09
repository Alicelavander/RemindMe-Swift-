//
//  CustomCell.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/02/09.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit

extension ViewController {
    
    // リストにどれだけ表示するか設定をする
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = list[indexPath.row]
        performSegue(withIdentifier: "detailTodo", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // cellの中身を決定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 自分で作ったカスタムセルに変更する
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell, for: indexPath) as! TodoCell
        let item = list[indexPath.row] // 表示するアイテムを決める
        cell.titleLabel.text = item.title
        cell.detailLabel.text = "テックスーパー"
        switch item.colorTag {
        case 0:
            cell.colorView.backgroundColor = UIColor()
            break
            
        case 1:
            cell.colorView.backgroundColor = UIColor(hex: Color.blue)
            break
            
        case 2:
            cell.colorView.backgroundColor = UIColor(hex: Color.green)
            break
            
        case 3:
            cell.colorView.backgroundColor = UIColor(hex: Color.yellow)
            break
            
        default:
            break
        }
        return cell
    }
    
    // セルの高さを設定する
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

