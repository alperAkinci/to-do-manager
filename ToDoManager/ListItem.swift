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
    
    var completionDate : NSDate?
    var categoryColor : UIColor?
    var categoryName : CategoryName = CategoryName.ToDo{
        didSet{
            
            // set category color after category has set
            setCategoryColor(categoryName)
            
        
        }
    }
    
    
    
    //Initializers
    
    override init(){}
    
    init(title : String){
        
        self.title = title
    
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