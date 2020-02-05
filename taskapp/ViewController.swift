//
//  ViewController.swift
//  taskapp
//
//  Created by ShibayamaKentaro on 2020/01/31.
//  Copyright © 2020 ShibayamaKentaro. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm=try! Realm()
    
    
    
    
    // DB内のタスクが格納されるリスト。
    // 日付の近い順でソート：昇順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)  // ←追加
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        
        searchbuttontext.isEnabled=false
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する.  --- ここから ---
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        // --- ここまで追加 ---
        
        
        return cell    }
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath )-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        // --- ここから ---
        if editingStyle == .delete {
            
            // 削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            
            // ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            
            
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            // --- ここまで追加 ---
            
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        }
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    
   
        
    @IBAction func searchbutton(_ sender: Any) {
    
    
        searchField.text=""
        
        searchbuttontext.isEnabled=false
        
        searchbuttontext.setTitle("category", for: .normal)
        
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
        
    }
    
    
    
    
    @IBAction func textFieldchange(_ sender: Any) {
        if searchField.text != ""{
        taskArray=try! Realm().objects(Task.self).filter("category='\(searchField.text!)'").sorted(byKeyPath: "date", ascending: true )
            tableView.reloadData()
            
        }
        searchbuttontext.setTitle("キャンセル",for: .normal)
        searchbuttontext.isEnabled=true
        if searchField.text=="" {
            searchbuttontext.isEnabled=false
            searchbuttontext.setTitle("category",for: .normal)
            
   taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
            
        }
        
    }
    
    
    
    @IBOutlet weak var searchbuttontext: UIButton!
    
    
    @IBOutlet weak var searchField: UITextField!
    
    
    
    
}


/*var jadgebutton:Int!=nil
 
 @IBOutlet weak var searchtext: UITextField!
 
 lazy var category=searchtext.text!
 
 
 @IBOutlet weak var searchbutton: UIButton!
 
 
 @IBAction func seachbutton(_ sender: Any) {
 if jadgebutton==nil{
 var categoryfilter =
 try! Realm().objects(Task.self).filter("category != category")
 var countdata=categoryfilter.count
 
 var indexpaths=0
 
 //tableView.deleteRows(at: [indexpaths], with: .fade)
 
 
 for indexpaths in 1...countdata{
 
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 }
 }
 
 
 
 
 @IBOutlet weak var searchbar: UIButton!*/






