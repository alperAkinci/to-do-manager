//
//  CategoryPickerViewController.swift
//  ToDoManager
//
//  Created by Alper on 07/11/16.
//  Copyright © 2016 alper. All rights reserved.
//


import UIKit

//MARK: - Categories
enum CategoryName : String{
    
    case ToRemember = "To Remember"
    case ToBuy = "To Buy"
    case ToDo = "To Do"
    case ToCall = "To Call"
    case ToVisit = "To Visit"
    
    static let allValues = [ToRemember,ToBuy,ToDo,ToCall,ToVisit]
    
    func color() -> UIColor{
        
        var color : UIColor
        switch self{
        case CategoryName.ToDo:
            color = UIColor.redColor()
        case CategoryName.ToCall:
            color = UIColor.blueColor()
        case CategoryName.ToBuy:
            color = UIColor.greenColor()
        case CategoryName.ToRemember:
            color = UIColor.orangeColor()
        case CategoryName.ToVisit:
            color = UIColor.purpleColor()
        }
        
        return color
        
    }
    
}

//MARK: - CategoryPickerViewControllerDelegate Protocol
protocol CategoryPickerViewControllerDelegate: class {
    
    func categoryPicker(picker: CategoryPickerViewController,didPickCategory categoryName: CategoryName)
    
}

//MARK: - CategoryPickerViewController Class

class CategoryPickerViewController: UITableViewController {
    
    
    weak var delegate : CategoryPickerViewControllerDelegate?
    
    //Hold an array of all category names
    let categories = CategoryName.allValues
    var selectedCategory : CategoryName?
    
    
    //MARK: TableViewControllerDelegate Methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Category Cell", forIndexPath: indexPath) as UITableViewCell
        
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.rawValue
        cell.textLabel?.textColor = category.color()
        
        configureSelectionMarkForCell(cell, withCategoryName: category)
        
        return cell
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate{
            
            let categoryName = categories[indexPath.row]
            delegate.categoryPicker(self, didPickCategory: categoryName)
        
        }
    }
    
    //MARK: Convenience Methods
    func configureSelectionMarkForCell(cell: UITableViewCell, withCategoryName category : CategoryName) {
        
        if category == selectedCategory {
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
    
    }
    

    

}
