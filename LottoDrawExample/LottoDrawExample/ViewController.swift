//
//  ViewController.swift
//  LottoDrawExample
//
//  Created by 박지수 on 03/06/2019.
//  Copyright © 2019 박지수. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var databasePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        let fileMgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        databasePath = docsDir + "/lotto.db"
        
        NSLog("============"+databasePath)
        
        if !fileMgr.fileExists(atPath: databasePath as String) {
            let db = FMDatabase(path: databasePath as String)
            
            if db == nil {
                NSLog("DB 생성 오류")
            } else {
                NSLog("DB 생성 성공")
            }
            
            if ((db.open()) != nil) {
                NSLog("DB 연결 성공")
                
                let sql_statement = "Create table if not exists lotto(id integer primary key autoincrement, number1 integer, number2 integer, number3 integer, number4 integer, number5 integer, number6 integer)"
                if !(db.executeStatements(sql_statement)) {
                    NSLog("테이블 생성 오류")
                } else {
                    NSLog("테이블 생성 성공")
                }
                
                db.close()
            } else {
                NSLog("DB 연결 오류")
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lottoNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lottoCell", for: indexPath as IndexPath) as! LottoCell
        
        let row: Int = indexPath.row
        
        cell.number1.text = "\(lottoNumbers[row][0])"
        cell.number2.text = "\(lottoNumbers[row][1])"
        cell.number3.text = "\(lottoNumbers[row][2])"
        cell.number4.text = "\(lottoNumbers[row][3])"
        cell.number5.text = "\(lottoNumbers[row][4])"
        cell.number6.text = "\(lottoNumbers[row][5])"
        
        return cell
    }
    
    var lottoNumbers = Array<Array<Int>>()
    
    @IBAction func doDraw(_ sender: UIBarButtonItem) {
        lottoNumbers = Array<Array<Int>>()
        
        var originalNumbers = Array(1 ... 45)
        var index = 0
        
        for _ in 0 ... 4 {
            originalNumbers = Array(1 ... 45)
            var columnArray = Array<Int>()
            
            for _ in 0 ... 5 {
                index = Int(arc4random_uniform(UInt32(originalNumbers.count)))
                columnArray.append(originalNumbers[index])
                originalNumbers.remove(at: index)
            }
            
            columnArray.sort(by: {$0 < $1})
            lottoNumbers.append(columnArray)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func loadData(_ sender: UIBarButtonItem) {
        lottoNumbers = Array<Array<Int>>()
        let db = FMDatabase(path: databasePath as String)
        
        if((db.open()) != nil) {
            let selectQuery = "select number1, number2, number3, number4, number5, number6 from lotto"
            let result: FMResultSet? = db.executeQuery(selectQuery, withArgumentsIn: [])
            if result != nil{
                while result!.next() {
                    var columnArray = Array<Int>()
                    columnArray.append(Int(result!.string(forColumn: "number1")!)!)
                    columnArray.append(Int(result!.string(forColumn: "number2")!)!)
                    columnArray.append(Int(result!.string(forColumn: "number3")!)!)
                    columnArray.append(Int(result!.string(forColumn: "number4")!)!)
                    columnArray.append(Int(result!.string(forColumn: "number5")!)!)
                    columnArray.append(Int(result!.string(forColumn: "number6")!)!)
                    lottoNumbers.append(columnArray)
                    NSLog("자료 불러오기 성공")
                }
            } else {
                NSLog("자료 불러오기 실패")
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        let db = FMDatabase(path: databasePath as String)
        
        if ((db.open()) != nil) {
            db.executeUpdate("delete from lotto", withArgumentsIn: [])
            
            if ((db.hadError()) != nil) {
                NSLog("DB 초기화 오류")
            }
            
            for numbers in lottoNumbers {
                let insertQuery = "insert into lotto(number1, number2, number3, number4, number5, number6) values (\(numbers[0]), \(numbers[1]), \(numbers[2]), \(numbers[3]), \(numbers[4]), \(numbers[5]))"
                db.executeUpdate(insertQuery, withArgumentsIn: [])
                
                if((db.hadError()) != nil) {
                    NSLog("저장 성공 \(insertQuery)")
                } else {
                    NSLog("저장 오류 \(insertQuery)")
                }
            }
        } else {
            NSLog("DB 연결 오류")
        }
    }
}


