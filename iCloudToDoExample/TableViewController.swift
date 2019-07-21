//
//  TableViewController.swift
//  iCloudToDoExample
//
//  Created by 박지수 on 05/06/2019.
//  Copyright © 2019 박지수. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    let data: NSMutableArray = []
    
    class todoRecord {
        var title: String!
        var isComplete: Bool!
        
        init(title: String, isComplete: Bool) {
            self.title = title
            self.isComplete = isComplete
        }
    }
    
    var isSub = false
    var rowNum: Int!
    
    override func viewDidLoad() {
        data.add([todoRecord(title: "title1", isComplete: false), [] as NSMutableArray])
        data.add([todoRecord(title: "title2", isComplete: false), [] as NSMutableArray])
        data.add([todoRecord(title: "title3", isComplete: false), [] as NSMutableArray])
        
        ((data[0] as! NSArray)[1] as! NSMutableArray).add(todoRecord(title: "sub - title1", isComplete: false))
        ((data[1] as! NSArray)[1] as! NSMutableArray).add(todoRecord(title: "sub - title2", isComplete: false))
        ((data[2] as! NSArray)[1] as! NSMutableArray).add(todoRecord(title: "sub - title3", isComplete: false))
        
        if isSub {
            navigationItem.title = ((data[rowNum] as! NSArray)[0] as! todoRecord).title
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.blue
        refreshControl.addTarget(self, action: #selector(addTodo), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSub {
            return ((data[rowNum] as! NSArray)[1] as! NSMutableArray).count
        } else {
            return data.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "todoCell", for: indexPath) as! TodoCell
        let row: Int = indexPath.row
        
        var record: todoRecord!
        
        if isSub {
            record = ((data[rowNum] as! NSArray)[1] as! NSMutableArray)[row] as! todoRecord
            cell.isSub = true
            cell.rowNum = rowNum
        } else {
            record = (data[row] as! NSArray)[0] as! todoRecord
            cell.todoCount.setTitle("\(((data[row] as! NSArray)[1] as! NSMutableArray).count)", for: UIControl.State.normal)
        }
        
        cell.isComplete = record.isComplete
        cell.tableViewController = self
        cell.todoTitle.text = record.title
        
        if cell.isComplete == true {
            cell.todoTitle.textColor = UIColor.gray
        } else {
            cell.todoTitle.textColor = UIColor.black
        }
        
        cell.todoTitle.isEnabled = false
        
        let doubleTapGR = UITapGestureRecognizer(
            target: self, action: #selector(doubleTap))
        doubleTapGR.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTapGR)
        
        let swipeRightGR = UISwipeGestureRecognizer(
            target: self, action: #selector(swipe))
        let swipeLeftGR = UISwipeGestureRecognizer(
            target: self, action: #selector(swipe))
        swipeRightGR.direction = UISwipeGestureRecognizer.Direction.right
        cell.addGestureRecognizer(swipeRightGR)
        swipeLeftGR.direction = UISwipeGestureRecognizer.Direction.left
        cell.addGestureRecognizer(swipeLeftGR)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableViewController = segue.destination as? TableViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableViewController.isSub = true
                tableViewController.rowNum = indexPath.row
            }
        }
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if let cell = tableView.cellForRow(at: indexPath) as? TodoCell {
                    cell.todoTitle.isEnabled = true
                    cell.todoTitle.becomeFirstResponder()
            }
        }
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer) {
        let point = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if sender.direction == .left {
            if isSub {
                ((data[rowNum!] as! NSArray)[1]
                    as! NSMutableArray).removeObject(at: indexPath!.row)
            } else {
                data.removeObject(at: indexPath!.row)
            }
        }
        
        else if sender.direction == .right {
            var record: todoRecord!
            
            if isSub {
                var record: todoRecord!
                
                if isSub {
                    record = ((data[rowNum] as! NSArray)[1]
                    as! NSMutableArray)[indexPath!.row] as! todoRecord
                } else {
                    record = (data[indexPath!.row]
                    as! NSArray)[0] as! todoRecord
                }
                
                record.isComplete = !record.isComplete
            }
            
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TodoCell {
            cell.todoTitle.resignFirstResponder()
            cell.todoTitle.isEnabled = false
        }
    }
    
    @objc func addTodo() {
        let record = todoRecord(title: "", isComplete: false)
        
        if isSub {
            ((data[rowNum!] as! NSArray)[1]
                as! NSMutableArray).insert(record, at: 0)
        } else {
            data.insert([record,[] as NSMutableArray], at: 0)
        }
        
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
}
