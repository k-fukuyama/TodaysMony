//
//  resultViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/03/12.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class resultViewController: UIViewController{
  
  let ud = UserDefaults.standard

  
  @IBOutlet weak var oneMonthMoneyRemain: UILabel!
  
  var SegueUsedMoney = 0
  let testman = UserDefaults()
  
  override func viewDidLoad() {
        super.viewDidLoad()
   let dvc = detailmonyViewController()
//    testman.integer(forKey: "testmoney")
//    oneMonthMoneyRemain.text! = String(describing: testman)
    
//    var detailVC = detailmonyViewController()
//    var detailVCOnemonthMoney = detailVC.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney")
//    var remain = detailVCOnemonthMoney - SegueUsedMoney
//    detailVC.SaveOneMonthMoneyResult.set(remain, forKey: "SaveMoney")
    let vc = ViewController()
    let aaa = dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney")
    
      let formatter = NumberFormatter()
      formatter.numberStyle = NumberFormatter.Style.decimal
      formatter.groupingSeparator = ","
      formatter.groupingSize = 3

        // Do any additional setup after loading the view.
      
      if ud.integer(forKey: "aaa") != nil{
        result = ud.integer(forKey: "aaa") + result
        poolmony = result
        ud.set(result, forKey: "aaa")
      }else{
        var trueresult = result
        poolmony = trueresult
        
        ud.set(trueresult, forKey: "aaa")
      }
    
      
//      monylabel.text = "¥\(formatter.string(from: ud.integer(forKey: "aaa") as! NSNumber)!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  var poolmony = 0
  var result = 0
    

  @IBOutlet weak var monylabel: UILabel!
  
  
  
  @IBAction func reset(_ sender: Any) {
    var alert = UIAlertController(title:"残りの金額をリセット",
                                  message:"残りの金額をリセットします",
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title:"リセットする", style:.destructive, handler:{ action in
      self.ud.removeObject(forKey: "aaa")
      self.oneMonthMoneyRemain.text! = String(self.ud.integer(forKey: "aaa"))
    }))
    
    alert.addAction(UIAlertAction(title:"リセットしない", style: .cancel))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  
  
  
  func ontap(){
    let dvc = detailmonyViewController()
    oneMonthMoneyRemain.text! = String(dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
  }
  
  func hoge(){
  
    let dvc = detailmonyViewController()
//    let vc = ViewController()
//    let atai = dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney") - vc.TodaysTotalUsedMoney.integer(forKey: "TodaysTotalUd")
//    print(atai)
//    OneMonthMoneyRemain.text! = String(atai)
    
   
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

extension resultViewController: MyTabBarDelegate {

  func didSelectTab(tabBarController: UITabBarController) {
    ontap()
  }
}


