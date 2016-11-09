//
//  ViewController.swift
//  ToDoManager
//
//  Created by Alper on 04/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate , TaskDetailViewControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    
    var taskListCore = [[CoreListItem]]()
    var uncompletedTasksCore = [CoreListItem]()
    var completedTasksCore = [CoreListItem]()
    
    var selectedIndexPath : NSIndexPath?
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskListCore = [uncompletedTasksCore,completedTasksCore]
        fetchReminders()
        
        print(taskListCore)
        
    }

    
    
    //MARK: UITableViewDelegate , UITableViewDataSource Methods


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return taskListCore.count
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListCore[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListItem", forIndexPath: indexPath) as! ListItemCell
        
        
        let item = taskListCore[indexPath.section][indexPath.row]
        
        configureCompletionMarkForCell(cell, withListItem: item)
        configureTextForCell(cell, withListItem: item)
        configureDateForCell(cell, withListItem: item)
        
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            let item = taskListCore[indexPath.section][indexPath.row] as CoreListItem
            item.toggleCompletionMark()
            
            configureSectionOfCell(indexPath, withListItem: item)
            configureCompletionMarkForCell(cell, withListItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
        appDelegate.saveContext()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName : String
        
        section == 0 ? (sectionName = "Uncompleted") : (sectionName = "Completed")
        
        return sectionName
    }
    
    func tableView(tableView: UITableView,commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // remove from saved data
        managedContext.deleteObject(taskListCore[indexPath.section][indexPath.row] as NSManagedObject)
        
        //cancel the local notification if there is
        
        let itemID = taskListCore[indexPath.section][indexPath.row].itemID as! Int
        let listItem = ListItem(itemID: itemID)
        
        if let notification = listItem.notificationForThisItem() {
            print("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }

        // remove from taskList data array
        taskListCore[indexPath.section].removeAtIndex(indexPath.row)
        
        //remove the row from tableView
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths,withRowAnimation: .Automatic)
        
        
        
        appDelegate.saveContext()
    }
    
    
    // MARK: Prepare For Seque
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddNewTask" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! TaskDetailViewController
            controller.delegate = self
        
        }else if segue.identifier == "EditTask"{
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! TaskDetailViewController
            controller.delegate = self
            //Get the indexPath from button placed in UITableViewCell
            if let button = sender as? UIButton{

                let rootViewPoint = button.superview!.convertPoint(button.center, toView: self.tableView)
                
                if let indexPath = self.tableView.indexPathForRowAtPoint(rootViewPoint){
                    selectedIndexPath = indexPath
                    //Convert taskListCore item to listItem and send it to taskdetailVC
                    controller.itemToEdit = convertToListItem(FromCoreListItem: taskListCore[indexPath.section][indexPath.row] )
                    
                }
            }
        
        }
    }
    
    //MARK: Convenience Methods
    
    func configureCompletionMarkForCell(cell: UITableViewCell, withListItem item : CoreListItem) {
        
        guard let isCompleted = item.isCompleted as? Bool else {
            print ("isChecked value is nil")
            return
        }
        
        if isCompleted {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }
    
    func configureTextForCell(cell: ListItemCell,
                              withListItem item: CoreListItem) {
        
        cell.title.text = item.title
        cell.categoryName.text = item.getCategoryName().rawValue
        cell.categoryName.textColor = item.getCategoryName().color()
    
    }
    
    func configureSectionOfCell(indexPath : NSIndexPath,withListItem item: CoreListItem) {
        
        taskListCore[indexPath.section].removeAtIndex(indexPath.row)
        
        if item.isCompleted as! Bool{
            taskListCore[1].append(item)
        }else{
            taskListCore[0].append(item)
        }
    }
    
    func configureDateForCell(cell: ListItemCell,
                              withListItem item: CoreListItem) {
        
        if let completionDate = item.completionDate{
        
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            cell.completionDate.text = formatter.stringFromDate(completionDate)
        }else {
            
            cell.completionDate.text = " "
        }
        
    }
    
    func convertToListItem(FromCoreListItem coreListItem : CoreListItem)->ListItem{
        
        //Title
        let item = ListItem(title: coreListItem.title!)
        //isComleted
        item.isCompleted = coreListItem.isCompleted as! Bool
        //itemID
        item.itemID = coreListItem.itemID as! Int
        //shouldRemind
        item.shouldRemind = coreListItem.shouldRemind as! Bool
        //comletionDate
        item.completionDate = coreListItem.completionDate
        //categoryName
        item.categoryName = coreListItem.getCategoryName()
    
        return item
    }
    
    func convertToCoreListItem(FromListItem listItem : ListItem)->CoreListItem{
        
        //1 - Access ManagedObjectContext which lives in AppDelegate, to access it you must get reference of AppDelegate first
        let managedContext = appDelegate.managedObjectContext
        
        //2 - Create a new managedObject and insert it into a managed object context .
        let entity  = NSEntityDescription.entityForName("CoreListItem", inManagedObjectContext: managedContext)
        
        let coreListItem = CoreListItem(entity: entity!, insertIntoManagedObjectContext: managedContext)
        //3 - With an NSManagedObject , set the attributes 
        coreListItem.title = listItem.title
        coreListItem.isCompleted = listItem.isCompleted
        coreListItem.itemID = listItem.itemID
        coreListItem.shouldRemind = listItem.shouldRemind
        coreListItem.completionDate = listItem.completionDate
        coreListItem.categoryName = listItem.categoryName?.rawValue
        //4 - Commit the changes and save to disk by calling save on the managed object context
        do {
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error),\(error.userInfo)")
        }
        
        return coreListItem
        
        
    }
    
    func fetchReminders () {
        //1 - before we do anything in CoreData , we need a managed object context . Pull up AppDelegate and grab a referance to its managed object context.
        let managedContext = appDelegate.managedObjectContext
        
        //2 - Make Fetching request via NSFetchRequest
        let fetchRequest = NSFetchRequest(entityName: "CoreListItem")
        
        //3 - Return an array of managed context that specified by fetch request
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let coreListArray = results as! [CoreListItem]
            
            for item in coreListArray {
                if let isCompleted = item.isCompleted as? Bool{
                    isCompleted ? taskListCore[1].append(item) : taskListCore[0].append(item)
                }
            }
            
        }catch let error as NSError{
            print("Could not fetch \(error),\(error.userInfo)")
        }
        
    }
    
        
    //MARK: TaskDetailViewControllerDelegate
    
    func taskDetailViewControllerDidCancel(controller: TaskDetailViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func taskDetailViewController(controller: TaskDetailViewController, didFinishAddingNewTask item: ListItem) {
        
        //convert ListItem to CoreListItem, //save data
        let coreListItem = convertToCoreListItem(FromListItem: item)
        
        //Add new row to uncompleted section of list , section 0
        let newRowIndex = taskListCore[0].count
        taskListCore[0].append(coreListItem)
        
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths,withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func taskDetailViewController(controller: TaskDetailViewController,didFinishEditingNewTask item: ListItem){
        
        let coreListItem = convertToCoreListItem(FromListItem: item)
        var section : Int
        coreListItem.isCompleted as! Bool ? (section = 1) : (section = 0)
        
        //delete the item before edit
        managedContext.deleteObject(taskListCore[selectedIndexPath!.section][selectedIndexPath!.row] as NSManagedObject)
        
        //add edited item to task array
        taskListCore[section][selectedIndexPath!.row] = coreListItem
        
        //reload tableView
        tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: .Automatic)
       
        appDelegate.saveContext()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}

