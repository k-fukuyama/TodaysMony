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
//    vcLogs = ViewController().todaysUsedLog.array(forKey: "TodaysMoneyLog")
    vcLogs = ViewController().hashLog.dictionary(forKey: "hash")
    vcTimeLogs = ViewController().todaysUsedLog.array(forKey: "Time")
    vcTotal = ViewController().total.integer(forKey: "total")
    table.reloadData()
  }
  
  
//  var vcLogs = ViewController().todaysUsedLog.array(forKey: "TodaysMoneyLog")
   var vcLogs = ViewController().hashLog.dictionary(forKey: "hash")
  var vcTimeLogs = ViewController().todaysUsedLog.array(forKey: "Time")
  var vcTotal = ViewController().total.integer(forKey: "total")
  let vc = ViewController()
  var total = 0
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if let vcLogs = vcLogs{
      return vcLogs.count
//      return test.count
    }else{
      return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//    cell.textLabel!.text = String("\(describing: vcLogs![indexPath.row])円")
    
    if let vclogs = vcLogs{
      let log = vclogs.map{vc.CommaAdd(comma: $0 as! Int)}
      cell.textLabel!.text = String(log[indexPath.row])
      
    }else{
      return cell
    }
    
    if let timeLogs = vcTimeLogs{
      cell.detailTextLabel!.text = String(describing: timeLogs[indexPath.row])
    }else{
      return cell
    }
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
    
    
    let view = UIView()
    view.frame = CGRect(x: 0, y: 0, width: self.table.frame.size.width, height: 100)
    
    let screenWidth:CGFloat = view.frame.size.width
    let screenHeight:CGFloat = view.frame.size.height
    
    let headerLabel = UILabel()
    headerLabel.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
    headerLabel.center = CGPoint(x: screenWidth/2, y: screenHeight/4)
    headerLabel.text = String("合計金額：\(vc.CommaAdd(comma: vcTotal))")
    headerLabel.textColor = UIColor.black
    headerLabel.textAlignment = .center
    view.addSubview(headerLabel)
    
    return view
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
