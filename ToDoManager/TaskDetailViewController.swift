//
//  DetailTaskViewController.swift
//  ToDoManager
//
//  Created by Alper on 06/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit


//MARK: - TaskDetailViewControllerDelegate Protocol

protocol TaskDetailViewControllerDelegate: class {
    
    //when pressed Cancel button
    func taskDetailViewControllerDidCancel(controller: TaskDetailViewController)
    
    //when pressed Done button for New Task 
    func taskDetailViewController(controller: TaskDetailViewController,didFinishAddingNewTask item: ListItem)
    
    //when pressed Done button for Edit Task
    func taskDetailViewController(controller: TaskDetailViewController,didFinishEditingNewTask item: ListItem)
}



//MARK: TaskDetailViewController Class
class TaskDetailViewController: UITableViewController , UITextFieldDelegate,CategoryPickerViewControllerDelegate{
    
    
    weak var delegate : TaskDetailViewControllerDelegate?
    var itemToEdit : ListItem?
    var categoryName : CategoryName? // Default Value
    var completionDate = NSDate()
    var datePickerVisible = false
    
    // MARK: Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var remindMeSwitch: UISwitch!
    @IBOutlet weak var completionDateLabel: UILabel!
    
    
    // MARK: Actions
    @IBAction func cancel(sender: AnyObject) {
        
        titleTextField.resignFirstResponder()//close textfield before viewcontroller is dismissed
        delegate?.taskDetailViewControllerDidCancel(self)
    
    
    }
    
    @IBAction func done(sender: AnyObject) {
        
        if let item = itemToEdit{
            //edit the task item object
            item.title = titleTextField.text!
            item.categoryName = categoryName
            item.shouldRemind = remindMeSwitch.on
            item.completionDate = completionDate
            item.scheduleNotification()
        
            delegate?.taskDetailViewController(self, didFinishEditingNewTask: item)
            
    
        }else{
            //initalize new task item object
            let item = ListItem(title: titleTextField.text!)
            item.shouldRemind = remindMeSwitch.on
            item.completionDate = completionDate
            item.scheduleNotification()
            titleTextField.resignFirstResponder()//close textfield before viewcontroller is dismissed
            delegate?.taskDetailViewController(self, didFinishAddingNewTask: item)
        
        }

    }
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        completionDate = sender.date
        updateCompletionDateLabel()
    }
    
    @IBAction func remindMeSwitchToggled(sender: UISwitch) {
        
        if remindMeSwitch.on {
            let notificationSettings = UIUserNotificationSettings(
                forTypes: [.Alert , .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(
                    notificationSettings)
        }
        
    }
    
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        
        if let item = itemToEdit {
            title = "Edit Task"
            
            //navigation bar details
            doneBarButton.enabled = true
            //title details
            titleTextField.text = item.title
            //category details
            categoryName = item.categoryName!
            categoryNameLabel.text = categoryName!.rawValue//default is To Do
            categoryNameLabel.textColor = categoryName!.color()// default is blue
            //notification details
            remindMeSwitch.on = item.shouldRemind
            //if completion Date of task is nil then assign it current time
            completionDate = item.completionDate ?? NSDate()
        }
        
        updateCompletionDateLabel()
        
    }
    

    //MARK: Prepare For Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChooseCategory" {
            let controller = segue.destinationViewController
                as! CategoryPickerViewController
            controller.delegate = self
            controller.selectedCategory = categoryName
        }
        
    }
    
    //MARK: TextFieldDelegate Methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        
        // Disable the doneBarButton if there is no text inside the textfield
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(
            range, withString: string)
        
        if newText.length > 0 {
            doneBarButton.enabled = true
        } else {
            doneBarButton.enabled = false
        }
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
    //MARK: TableViewControllerDelegate Methods
    
    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 2 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 2 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView,heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        titleTextField.resignFirstResponder()// in case textField is visible
        
        if indexPath.section == 2 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            }else{
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView,indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        var indexPath = indexPath
        if indexPath.section == 2 && indexPath.row == 2 {
            //make date picker same intent level with the completion date row
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)//
        }
        return super.tableView(tableView,indentationLevelForRowAtIndexPath: indexPath)
    }
    
    
    // to select only a category cell on the section 1
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 || (indexPath.section == 2 && indexPath.row == 1){
            return indexPath
        }else {
            return nil
        }
    }
    
    
    //MARK: CategoryPickerViewControllerDelegate Methods
    func categoryPicker(picker: CategoryPickerViewController, didPickCategory categoryName: CategoryName) {
        
        self.categoryName =  categoryName
        categoryNameLabel.text = categoryName.rawValue
        categoryNameLabel.textColor = categoryName.color()
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    //MARK: Convenience Methods
    func updateCompletionDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        completionDateLabel.text = formatter.stringFromDate(completionDate)
    }
    
    func showDatePicker(){
        datePickerVisible = true
        
        //show date of the selected task
        datePicker.setDate(completionDate, animated: false)
        
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 2)
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 2)
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 2)
            
        tableView.beginUpdates()
        
        tableView.reloadRowsAtIndexPaths([indexPathDateRow],withRowAnimation: .None)
        tableView.deleteRowsAtIndexPaths([indexPathDatePicker],withRowAnimation: .Fade)
        
        tableView.endUpdates()
        
        }
    }
    
    
    
    
}
