//
//  TableViewCell.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/02/08.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var Color: UIView!
    @IBOutlet weak var ToDo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
