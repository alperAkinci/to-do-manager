//
//  ListItem+CoreDataProperties.swift
//  ToDoManager
//
//  Created by Alper on 08/11/16.
//  Copyright © 2016 alper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CoreListItem {

    @NSManaged var title: String?
    @NSManaged var isCompleted: NSNumber?
    @NSManaged var itemID: NSNumber?
    @NSManaged var shouldRemind: NSNumber?
    @NSManaged var completionDate: NSDate?
    @NSManaged var categoryName: String?
    
    func toggleCompletionMark(){
        if let isCompleted = isCompleted as? Bool{
           self.isCompleted = !isCompleted
        }
    }

    func getCategoryName()->CategoryName{
        if let categoryName = categoryName{
            switch categoryName {
            case "To Do":
                return .ToDo
            case "To Remember":
                return .ToRemember
            case "To Visit":
                return .ToVisit
            case "To Buy":
                return .ToBuy
            case "To Call":
                return .ToCall
            default:
                return .ToDo
            }
        
        }else{
            return .ToDo
        }
        
    }
    
}
