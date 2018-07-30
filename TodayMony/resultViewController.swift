//
//  resultViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/03/12.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class resultViewController: UIViewController {
  
  let ud = UserDefaults.standard

  @IBOutlet weak var OneMonthMoneyRemain: UILabel!
  
  var SegueUsedMoney = 0
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    print("渡せたかな\(SegueUsedMoney)")
    
    var detailVC = detailmonyViewController()
    var detailVCOnemonthMoney = detailVC.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney")
    var remain = detailVCOnemonthMoney - SegueUsedMoney
    detailVC.SaveOneMonthMoneyResult.set(remain, forKey: "SaveMoney")
    
    OneMonthMoneyRemain.text! = String(remain)
    
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
      
      
      monylabel.text = "¥\(formatter.string(from: ud.integer(forKey: "aaa") as! NSNumber)!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  var poolmony = 0
  var result = 0
    

  @IBOutlet weak var monylabel: UILabel!
  
  
  
  @IBAction func reset(_ sender: Any) {
    var alert = UIAlertController(title:"貯金額をリセット",
                                  message:"貯金額をリセットします",
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title:"貯金額をリセットする", style:.destructive, handler:{ action in
      self.ud.removeObject(forKey: "aaa")
      self.performSegue(withIdentifier: "todaysmony", sender: nil)
    }))
    
    alert.addAction(UIAlertAction(title:"リセットしない", style: .cancel))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  
  @IBAction func TodaysMonyPage(_ sender: Any) {
    performSegue(withIdentifier: "todaysmony", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "todaysmony"){
      let viewcontroller:ViewController = segue.destination as! ViewController
      viewcontroller.poolmonytwo = poolmony
    }
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



