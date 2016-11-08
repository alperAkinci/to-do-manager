//
//  SettingsViewController.swift
//  ToDoManager
//
//  Created by Alper on 08/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let settings = NSUserDefaults.standardUserDefaults()
    var isSwitchOn : Bool?// defaultValue
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBAction func done(sender: UIBarButtonItem) {
        
        if isSwitchOn != notificationSwitch.on{
        
            if notificationSwitch.on{
                print("Turn on all notifications")
                //set all items shouldRemind 1 
                //register for all notifications
            }else{
                print("Turn off all notifications")
                //set all items shouldRemind 0
                //cancel all local notifications
            }
        }
        
        settings.setBool(notificationSwitch.on, forKey: "SendMeNotifications")
        navigationController?.popViewControllerAnimated(true)
    
    }
    @IBAction func notificationSwitchToggled(sender: UISwitch) {
        
        
    }
    
    override func viewDidLoad() {
     
        if let isSwitch = settings.objectForKey("SendMeNotifications") as? Bool{
            notificationSwitch.on = isSwitch
            
        }else{
          settings.setBool(notificationSwitch.on, forKey: "SendMeNotifications")
        }
        isSwitchOn = notificationSwitch.on
    }
}
