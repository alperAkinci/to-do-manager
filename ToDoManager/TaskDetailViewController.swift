//
//  DetailTaskViewController.swift
//  ToDoManager
//
//  Created by Alper on 06/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit


protocol TaskDetailViewControllerDelegate: class {
    
    //when pressed Cancel button
    func taskDetailViewControllerDidCancel(controller: TaskDetailViewController)
    
    //when pressed Done button for Add New Task 
    func taskDetailViewController(controller: TaskDetailViewController,didFinishAddingNewTask item: ListItem)
    
    //when pressed Done button for Edit Task
    func taskDetailViewController(controller: TaskDetailViewController,didFinishEditingNewTask item: ListItem)
}




class TaskDetailViewController: UITableViewController , UITextFieldDelegate {
    
    
    weak var delegate : TaskDetailViewControllerDelegate?
    var itemToEdit : ListItem?

    // MARK: Outlets
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    // MARK: Actions
    @IBAction func cancel(sender: AnyObject) {
        
        titleTextField.resignFirstResponder()//close textfield before viewcontroller is dismissed
        delegate?.taskDetailViewControllerDidCancel(self)
    
    
    }
    
    @IBAction func done(sender: AnyObject) {
        
        if let item = itemToEdit{
            //edit the item object
            item.title = titleTextField.text!
            delegate?.taskDetailViewController(self, didFinishEditingNewTask: item)
            
    
        }else{
            //initalize new item object
            let item = ListItem()
            item.title = titleTextField.text!
            titleTextField.resignFirstResponder()//close textfield before viewcontroller is dismissed
            delegate?.taskDetailViewController(self, didFinishAddingNewTask: item)
        
        }

    }
    
    //View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        
        if let item = itemToEdit {
            title = "Edit Task"
            titleTextField.text = item.title
            doneBarButton.enabled = true
            
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
    
}
