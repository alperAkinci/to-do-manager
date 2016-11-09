//
//  ListItem.swift
//  ToDoManager
//
//  Created by Alper on 04/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import Foundation
import UIKit


class ListItem : NSObject {
    
    // Properties
    var title : String = ""
    var isCompleted : Bool = false

    var itemID: Int = random() % 1000000
    var shouldRemind = false
    var completionDate : NSDate?
    
    var categoryColor : UIColor?
    var categoryName : CategoryName?  
    
    //Initializers
    
    convenience init(title : String){
        self.init(title: title, categoryName:.ToDo)
        
    }
    
    init(title : String , categoryName: CategoryName){
        
        self.title = title
        self.categoryName = categoryName
        super.init()
    }
    
    init(itemID: Int){
        self.itemID = itemID
        super.init()
    }
    
    /*
    deinit {
        if let notification = notificationForThisItem() {
            print("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    */
    
    
    //Methods
    func toggleCompletionMark(){
        self.isCompleted = !isCompleted
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? Int
                where number == itemID {
                return notification
            }
        }
        return nil
    }
    
    func scheduleNotification() {
        print(NSDate())
        if shouldRemind && completionDate!.compare(NSDate()) != .OrderedAscending {
            //.OrderedAscending: completionDate comes not before the current date and time
            
            //if there is existing notification for task , cancel it
            let existingNotification = notificationForThisItem()
            
            if let notification = existingNotification {
                print("Found an existing notification : \(notification)")
                UIApplication.sharedApplication().cancelLocalNotification(
                    notification)
            }
            
        
            let localNotification = UILocalNotification()
            localNotification.fireDate = completionDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = ("Reminder:\(title)")
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID] // correct itemID
            
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            print(
                "Scheduled notification \(localNotification) for itemID \(itemID)")
            }
    }        
/*
func setCategoryColor(category : CategoryName){
    
    var color : UIColor
    switch category {
    case CategoryName.ToDo:
        color = UIColor.blueColor()
    case CategoryName.ToCall:
        color = UIColor.brownColor()
    case CategoryName.ToBuy:
        color = UIColor.greenColor()
    case CategoryName.ToRemember:
        color = UIColor.orangeColor()
    case CategoryName.ToVisit:
        color = UIColor.redColor()
    }
    
    categoryColor = color
    }
*/

}












