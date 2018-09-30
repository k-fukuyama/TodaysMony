//
//  logDetailViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/09/29.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class logDetailViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, changeLogDelgate {
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      print(keyBox)
    }
  
  var valueBox: [Int] = []
  var keyBox: [String] = []
  var vc = ViewController()
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    
    return valueBox.count
    
  }
  
  var saveString = ""
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = logTable.dequeueReusableCell(withIdentifier: "logDetailCell") as! logDetailTableViewCell
    cell.logTextfield.text! = String(valueBox[indexPath.row])
    
    
    //    cell?.textLabel!.text! = String(valueBox[indexPath.row])
    
    return cell
  }
  
    
  @IBOutlet weak var logTable: UITableView!
  
  @IBAction func backButton(_ sender: Any) {
    self.dismiss(animated: true, completion: {
      usedMoneyLogController().valueBox.removeAll()
    })
  }
  
  func textFieldDidEndEditing(cell: logDetailTableViewCell, value: String) {
    
    let index = logTable.indexPathForRow(at: cell.convert(cell.bounds.origin, to:logTable))
    print("変更されたインデックス\(value)")
    saveString = value
  }
  
  @IBAction func saveButton(_ sender: Any) {
    print("保存される値\(editedLog)")
    var vcHash = vc.hashLog.dictionary(forKey: "hash")
    vcHash![keyBox[0]] = Int(editedLog)
    vc.hashLog.set(vcHash, forKey: "hash")
    
  }
  
  
  
 
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
