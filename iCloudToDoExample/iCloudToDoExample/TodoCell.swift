//
//  TodoCell.swift
//  iCloudToDoExample
//
//  Created by 박지수 on 05/06/2019.
//  Copyright © 2019 박지수. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoCount: UIButton!
    
    var tableViewController: TableViewController!
    var isSub = false
    var rowNum: Int!
    var isComplete = false
    
    @IBAction func todoTitleChanged(_ sender: UITextField) {
        var record: TableViewController.todoRecord!
        
        if let indexPath = tableViewController.tableView.indexPath(for: self) {
            if self.isSub {
                record = ((tableViewController.data[rowNum!]as! NSArray)[1]
                as! NSMutableArray)[indexPath.row] as!
                TableViewController.todoRecord
            } else {
                record = (tableViewController.data[indexPath.row]
                as! NSArray)[0]
                as! TableViewController.todoRecord
            }
            
            record.title = self.todoTitle.text
        }
        
        sender.resignFirstResponder()
        sender.isEnabled = false
    }
    
    @IBAction func subCountTouch(_ sender: UIButton) {
        if let indexPath = tableViewController.tableView.indexPath(for: self) {
            tableViewController.tableView.selectRow(
                at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
    }
    
}
