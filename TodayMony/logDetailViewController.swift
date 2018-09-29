//
//  logDetailViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/09/29.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class logDetailViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
    }
    
  @IBOutlet weak var logTable: UITableView!
  
  @IBAction func backButton(_ sender: Any) {
    self.dismiss(animated: true, completion: {
      usedMoneyLogController().valueBox.removeAll()
    })
  }
  
  var valueBox: [Int] = []
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    

    return valueBox.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = logTable.dequeueReusableCell(withIdentifier: "logDetailCell")
    cell?.textLabel!.text! = String(valueBox[indexPath.row])
    
    return cell!
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
