//
//  ViewController.swift
//  reviewCoredata
//
//  Created by yuka on 2018/02/18.
//  Copyright © 2018年 yuka. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController
    ,UITableViewDelegate
    ,UITableViewDataSource
{


    var catList:[String] = ["初回表示"]
    var catDicList:[NSDictionary] = []
    @IBOutlet weak var catTitleField: UITextField!
    @IBOutlet weak var catListTableView: UITableView!
    
    var todoList:[String] = ["初回表示"]
    var todoDicList:[NSDictionary] = []
    @IBOutlet weak var todoTitleField: UITextField!
    @IBOutlet weak var toDoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        readCoreData(ref: "Category")
        catListTableView.delegate = self
        catListTableView.dataSource = self
        
        readCoreData(ref: "ToDo")
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
    }
    

    /* MARK:-
     MARK:リターンキーが押された時
     */

    @IBAction func tapReurn(_ sender: UITextField) {
        if sender.tag == 1
        {
            readCoreData(ref: "ToDo")
            toDoListTableView.reloadData()
        }
    }
    
    //[全表示]が押されたら、ToDoを全カテゴリ表示
    @IBAction func tapReadAll(_ sender: UIButton) {
        //配列初期化
        todoList = []
        todoDicList = []
        
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        do {
            
            
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults {
                let catTitle:String = result.value(forKey: "catTitle") as! String
                let title:String = result.value(forKey: "title") as! String
                let saveDate: Date = result.value(forKey: "saveDate") as! Date
                
                print("catTitle:\(catTitle) title:\(title) saveDate:\(saveDate)")
                
                todoList.append(title)
                
                let dic = ["title":title,"saveDate":saveDate] as [String:Any]
                todoDicList.append(dic as NSDictionary)
            }
        } catch {
        }
        
        toDoListTableView.reloadData()
        
    }
    
    /* MARK: 追加ボタンが押された時
        追加ボタンが押された
     *  - parameter param1 : UIButton
    */
    @IBAction func tapSave(_ sender: UIButton) {
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        
        switch sender.tag {
        case 1:
            //エンティティオブジェクトを作成
            let Category = NSEntityDescription.entity(forEntityName: "Category", in: viewContext)
            
            //エンティティにレコード（行）を挿入するためのオブジェクトを作成
            let newRecord = NSManagedObject(entity: Category!, insertInto: viewContext)
            
            //値のセット
            newRecord.setValue(catTitleField.text, forKey: "titleOfCat")
            newRecord.setValue(Date(), forKey: "catIDDate")
            
            do {
                
                try viewContext.save()
                readCoreData(ref: "Category")
            } catch {
                // tryでエラーした時の処理
                print(error)
            }
            
        default:  // tag = 2
            //ToDoエンティティオブジェクトを作成
            let ToDo = NSEntityDescription.entity(forEntityName: "ToDo", in: viewContext)
            
            //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
            let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
            
            //値のセット
            newRecord.setValue(catTitleField.text!, forKey: "catTitle")
            newRecord.setValue(todoTitleField.text!, forKey: "title") //値を代入
            newRecord.setValue(Date(), forKey: "saveDate") //値を代入
            
            do{
                //レコード（行）の即時保存
                try viewContext.save()
                
            } catch {
                print("ToDoリスト保存エラー")
            }
            readCoreData(ref: "ToDo")
            todoTitleField.text = ""  // 保存したらクリアしたいので
        }
    }
    
    //既に存在するデータの読み込み
    func readCoreData(ref:String){
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        

        switch ref {
        case "Category" :
            //配列初期化
            catList = []
            catDicList = []
            
            //どのエンティティからdataを取得してくるか設定
            let query:NSFetchRequest<Category> = Category.fetchRequest()
            
        
            do {
                

                //データを取得
                let fetchResults = try viewContext.fetch(query)

                //データを１つずつ取得
                for result: AnyObject in fetchResults {
                    let titleOfCat:String = result.value(forKey: "titleOfCat") as! String
                    let catIDDate: Date = result.value(forKey: "catIDDate") as! Date
                    
                    print("titleOfCat:\(titleOfCat) saveDate:\(catIDDate)")
                    
                    catList.append(titleOfCat)
                    
                    let dic = ["titleOfCat":titleOfCat,"catIDDate":catIDDate] as [String:Any]
                    catDicList.append(dic as NSDictionary)
                    
                }
            } catch {
            }
            
            catListTableView.reloadData()

        case "ToDo":
            //配列初期化
            todoList = []
            todoDicList = []
            //どのエンティティからdataを取得してくるか設定
            let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
            
            do {
                //カテゴリ欄がnilでなかったら検索カテゴリ名にカテゴリ欄の名前を入れる
                var searchCatTitle = ""
                if catTitleField.text != nil {
                    searchCatTitle = catTitleField.text!
                }
                
                //searchCatTitleのデータの絞り込み
                query.predicate = NSPredicate(format:"catTitle = %@", searchCatTitle)
                
                //データを一括取得
                let fetchResults = try viewContext.fetch(query)
                
                //データの取得
                for result: AnyObject in fetchResults {
                    let catTitle:String = result.value(forKey: "catTitle") as! String
                    let title:String = result.value(forKey: "title") as! String
                    let saveDate: Date = result.value(forKey: "saveDate") as! Date
                    
                    print("catTitle:\(catTitle) title:\(title) saveDate:\(saveDate)")
                    
                    todoList.append(title)
                    
                    let dic = ["title":title,"saveDate":saveDate] as [String:Any]
                    todoDicList.append(dic as NSDictionary)
                }
            } catch {
            }
            
            toDoListTableView.reloadData()
        default:
            return
        }

    }
    
    // Categoryの場合はcatIDDateで消す
    // ToDoの場合は、saveDateで消す
    // どちらもkeyにindexPath.rowを
    func deleteCoreData(ref:String,key:Int){
        //ここにCoreDataの1行デリート処理を書く
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        switch ref {
        case "Category":
            //データを取得するエンティティの指定
            //<>の中はモデルファイルで指定したエンティティ名
            let query: NSFetchRequest<Category> = Category.fetchRequest()
            
            //削除したい日付データをdicListから取り出す
            let dic = catDicList[key]
            let searchDate = dic["catIDDate"] as! Date

            //データの絞り込み
            query.predicate = NSPredicate(format:"catIDDate = %@", searchDate as NSDate)

            do {
                //削除したいデータの取得 1行だけのはず
                let fetchResults = try viewContext.fetch(query)
                
                //取得したデータを、削除指示
                for result: AnyObject in fetchResults {
                    let record = result as! NSManagedObject // 一行分のデータ
                    
                    viewContext.delete(record)
                    
                }
                
                //削除した状態を保存
                viewContext.delete(fetchResults[0])
                try viewContext.save()
                
            } catch  {
                print("削除失敗")
            }

        case "ToDo" :
            //データを取得するエンティティの指定
            //<>の中はモデルファイルで指定したエンティティ名
            let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            
            //削除したい日付データをdicListから取り出す
            let dic = todoDicList[key]
            let searchDate = dic["saveDate"] as! Date
            
            //データの絞り込み
            query.predicate = NSPredicate(format:"saveDate = %@", searchDate as NSDate)

            do {
                //削除したいデータの一括取得
                let fetchResults = try viewContext.fetch(query)
                
                //取得したデータを、削除指示
                for result: AnyObject in fetchResults {
                    let record = result as! NSManagedObject // 一行分のデータ
                    
                    viewContext.delete(record)
                    
                }
                
                //削除した状態を保存
                try viewContext.save()
                
            } catch  {
                
            }
        default:
            print(#function)
            print("デフォルトだよ")
        }
    }
    
    
    
    
    // MARK:-
    //行数決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.tag {
        case 1:  // category
            return catList.count
        default: // 2 todo
            return todoList.count

        }
    }
    
    //リスト表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 文字を表示するセルの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        switch tableView.tag {
        case 1:  // category
            
            cell.backgroundColor = UIColor.brown

            let int = indexPath.row + 1
            let satu:CGFloat = (CGFloat(int) / CGFloat(catList.count))
            
            cell.backgroundColor = UIColor(hue: 1.0, saturation: satu, brightness: 1, alpha: 1)
            cell.textLabel?.text = catList[indexPath.row]
            cell.textLabel?.textColor = UIColor.white

        default: // 2 todo
            // 表示文字の設定
            
            cell.textLabel?.text = todoList[indexPath.row]

        }
        // 文字を設定したセルを返す
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //カテゴリテーブルのセルをタップしたら、カテゴリのテキストフィールドにカテゴリ名を入れる
        
        if tableView.tag == 1 {
            let cell = tableView.cellForRow(at: indexPath)
            catTitleField.text = cell?.textLabel?.text
            
            readCoreData(ref: "ToDo")
            let int = indexPath.row + 1
            let satu:CGFloat = (CGFloat(int) / CGFloat(catList.count))

            toDoListTableView.backgroundColor = UIColor(hue: 1.0, saturation: satu, brightness: 1, alpha: 1)
            toDoListTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(#function)
        if editingStyle == .delete {
            //詳細メモが空のままフォーカスが外れた時に復活
            
            switch tableView.tag {
                case 1:
                    catList.remove(at: indexPath.row)
                    deleteCoreData(ref: "Category", key: indexPath.row)
                
                case 2:
                    todoList.remove(at: indexPath.row)
                    deleteCoreData(ref: "ToDo", key: (indexPath.row))
                
                default :
                    print("default")
                
            }
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

