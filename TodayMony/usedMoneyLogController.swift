//
//  usedMoneyLogController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/09/16.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class usedMoneyLogController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var table: UITableView!
  
  func ontap(){
    vcLogs = ViewController().todaysUsedLog.array(forKey: "TodaysMoneyLog")
    table.reloadData()
    print("こんにちは")
  }
  
  
  var vcLogs = ViewController().todaysUsedLog.array(forKey: "TodaysMoneyLog")
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let vcLogs = vcLogs{
      return vcLogs.count
    }else{
      return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel!.text = String("\(describing: vcLogs![indexPath.row])円")
    
    return cell
    
  }
  

    override func viewDidLoad() {
        super.viewDidLoad()
      

        // Do any additional setup after loading the view.
    }
  


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension usedMoneyLogController: MyTabBarDelegate{
  func didSelectTab(tabBarController: UITabBarController) {
    ontap()
  }
}
