//
//  ListItem.swift
//  ToDoManager
//
//  Created by Alper on 04/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import Foundation
import UIKit


class ListItem {
    
    // Properties
    var title : String = ""
    var isCompleted : Bool = false
    
    var completionDate : NSDate?
    var categoryColor : UIColor?
    var categoryName : CategoryName?{
        didSet{
            
            // set category color after category has set
            if let category = categoryName {
                setCategoryColor(category)
            }
        }
    }
    
    
    
    //Initializers
    
    init(){}
    
    init(title : String , isCompleted : Bool){
        
        self.title = title
        self.isCompleted = isCompleted
    
    }
    
    
    //Methods
    func setCategoryColor(category : CategoryName){
        
        var color : UIColor
        switch category {
        case CategoryName.ToDo:
            color = UIColor.blueColor()
        case CategoryName.ToCall:
            color = UIColor.brownColor()
        default:
            color = UIColor.yellowColor()
        }
        categoryColor = color
        
    }
    
    func toggleCompletionMark(){
        self.isCompleted = !isCompleted
    }
    
    

}



// Categories
enum CategoryName {
    
    case ToRemember
    case ToBuy
    case ToDo
    case ToCall
    case ToVisit
    
    func toString() -> String {
        switch self {
        case .ToRemember:
            return "To Remember"
        case .ToBuy:
            return "To Buy"
        case .ToCall:
            return "To Call"
        case .ToVisit:
            return "To Visit"
        case .ToDo:
            return "To Do"
        }
        
    }
}