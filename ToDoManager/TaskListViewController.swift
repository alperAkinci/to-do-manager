//
//  ViewController.swift
//  ToDoManager
//
//  Created by Alper on 04/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var uncompletedTasks = [ListItem]()
    var completedTasks = [ListItem]()
    var taskList = [[ListItem]]()
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskList = [uncompletedTasks,completedTasks]
        self.title = "Task List"
        
        let row0item = ListItem()
        row0item.title = "A new MacBook"
        row0item.isCompleted = false
        row0item.categoryName = CategoryName.ToBuy
        addList(row0item)
        
        let row3item = ListItem()
        row3item.title = "Go To SuperMarket"
        row3item.isCompleted = false
        row3item.categoryName = CategoryName.ToDo
        addList(row3item)
        
        let row1item = ListItem()
        row1item.title = "Prague"
        row1item.isCompleted = true
        row1item.categoryName = CategoryName.ToVisit
        addList(row1item)
        
        let row2item = ListItem()
        row2item.title = "WWDC 2016"
        row2item.isCompleted = true
        row2item.categoryName = CategoryName.ToRemember
        addList(row2item)
        
    }
    
    //MARK: UITableViewDelegate , UITableViewDataSource Methods


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return taskList.count
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return taskList[0].count
        }else if section == 1{
            return taskList[1].count
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListItem", forIndexPath: indexPath) as! ListItemCell
        
        
        let item = taskList[indexPath.section][indexPath.row]
        
        configureCompletionMarkForCell(cell, withListItem: item)
        configureTextForCell(cell, withListItem: item)
        
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            let item = taskList[indexPath.section][indexPath.row] as ListItem
            item.toggleCompletionMark()
            
            configureSectionForCell(indexPath, withListItem: item)
            configureCompletionMarkForCell(cell, withListItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName : String
        
        section == 0 ? (sectionName = "Uncompleted") : (sectionName = "Completed")
        
        return sectionName
    }
    
    //MARK: Convenience Methods
    func addList(item : ListItem){
        (item.isCompleted) ? taskList[1].append(item) : taskList[0].append(item)
    }
    
    
    func configureCompletionMarkForCell(cell: UITableViewCell, withListItem item : ListItem) {
        
        if item.isCompleted {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }
    
    func configureTextForCell(cell: ListItemCell,
                              withListItem item: ListItem) {
        
        cell.taskName.text = item.title
        cell.categoryName.text = item.categoryName!.toString()
    
    }
    
    func configureSectionForCell(indexPath : NSIndexPath,withListItem item: ListItem) {
        
        taskList[indexPath.section].removeAtIndex(indexPath.row)
        
        if item.isCompleted{
            taskList[1].append(item)
        }else{
            taskList[0].append(item)
        }
    }
    
}

