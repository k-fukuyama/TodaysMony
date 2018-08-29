//
//  resultViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/03/12.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class resultViewController: UIViewController, UITextFieldDelegate{
  
  let ud = UserDefaults.standard

  
  @IBOutlet weak var oneMonthMoneyRemain: UILabel!
  
  var SegueUsedMoney = 0
  
  @IBOutlet weak var remainMoneySetButtom: NSLayoutConstraint!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    let uiScreenSize = UIScreen.main.nativeBounds.size.width
    
    if uiScreenSize < 750{
      remainMoneySetButtom.constant = 20
    }else if uiScreenSize >= 1125{
      remainMoneySetButtom.constant = 115
    }
    
   let dvc = detailmonyViewController()
    
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  var poolmony = 0
  var result = 0
    

  @IBOutlet weak var monylabel: UILabel!
  
  
  let dvc = detailmonyViewController()
  let vc = ViewController()
  
  @IBAction func reset(_ sender: Any) {
    var alert = UIAlertController(title:"残りの金額をリセット",
                                  message:"残りの金額をリセットします",
                                  preferredStyle: .alert)
    
    
    
    alert.addAction(UIAlertAction(title:"リセットする", style:.destructive, handler:{ action in
      self.dvc.SaveOneMonthMoneyResult.removeObject(forKey: "SaveMoney")
      self.oneMonthMoneyRemain.text! = String(self.ud.integer(forKey: "aaa"))
    }))
    
    alert.addAction(UIAlertAction(title:"リセットしない", style: .cancel))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  
  
  
  func ontap(){
    oneMonthMoneyRemain.text! = vc.CommaAdd(comma: dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
    
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 7
    var str = textField.text! + string
    
    if str.characters.count < maxLength{
      return true
    }
    
    return false
    
  }
  
  
  
  @IBAction func remainMoneySetButton(_ sender: Any) {
    let remainMoneySetAlert = UIAlertController(title: "残りの金額を設定します",
                                                message: "金額を入力してください",
                                                preferredStyle: .alert)
    
    remainMoneySetAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
    
    remainMoneySetAlert.addTextField(configurationHandler:{(textField: UITextField) -> Void in
      textField.placeholder = "金額を入力してください"
      textField.delegate = self
      textField.keyboardType = UIKeyboardType.numberPad
      
      remainMoneySetAlert.addAction(UIAlertAction(title: "決定", style: .default, handler:{ action in
        if textField.text != ""{
         self.dvc.SaveOneMonthMoneyResult.set(Int(textField.text!), forKey: "SaveMoney")
          let viewRemain = self.vc.CommaAdd(comma: self.dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
          self.oneMonthMoneyRemain.text =  viewRemain
        }
      } ))
    } )
    self.present(remainMoneySetAlert, animated: true, completion: nil)
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


