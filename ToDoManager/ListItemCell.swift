//
//  ListItemCell.swift
//  ToDoManager
//
//  Created by Alper on 05/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBAction func editTask(sender: UIButton) {
    
    }
    
}
