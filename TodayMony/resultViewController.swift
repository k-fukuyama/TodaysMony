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
  let method = MethodStruct()
  let dvc = detailmonyViewController()

  
  @IBOutlet weak var oneMonthMoneyRemain: UILabel!
  
  var SegueUsedMoney = 0
  
  @IBOutlet weak var remainMoneySetButtom: NSLayoutConstraint!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    let uiScreenSize = UIScreen.main.nativeBounds.size.width
    
    if uiScreenSize < 750{
      remainMoneySetButtom.constant = 20
    }else if uiScreenSize >= 825.0{
      remainMoneySetButtom.constant = 115
    }
    
   
    
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
  
  let vc = ViewController()
  
  @IBAction func reset(_ sender: Any) {
    var AlertTitle = ""
    
    if segnum == 0{
      AlertTitle = "残りの金額をリセット"
    }else{
      AlertTitle = "貯められた金額をリセット"
    }
    var alert = UIAlertController(title: AlertTitle,
                                  message:"\(AlertTitle)します",
                                  preferredStyle: .alert)
    
    
    
    alert.addAction(UIAlertAction(title:"リセットする", style:.destructive, handler:{ action in
      
      if self.segnum == 0{
        self.dvc.SaveOneMonthMoneyResult.removeObject(forKey: "SaveMoney")
        self.oneMonthMoneyRemain.text! = String(self.ud.integer(forKey: "aaa"))
      }else{
        self.vc.remainResult.removeObject(forKey: "remain")
        self.vc.firstEnd.removeObject(forKey: "endCount")
        self.oneMonthMoneyRemain.text! = self.method.CommaAdd(comma: self.vc.remainResult.integer(forKey: "remain"))
      }
      
    }))
    
    alert.addAction(UIAlertAction(title:"リセットしない", style: .cancel))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  
  
  
  func ontap(){
    if segnum == 0{
      oneMonthMoneyRemain.text! = method.CommaAdd(comma: dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
    }else{
      oneMonthMoneyRemain.text! = method.CommaAdd(comma: ViewController().remainResult.integer(forKey: "remain"))
    }
    
    
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

    var title = ""
    
    if segnum == 0{
      title = "残りの金額を設定します"
    }else{
      title = "貯められた金額を修正します"
    }
    let remainMoneySetAlert = UIAlertController(title: title,
                                                message: "金額を入力してください",
                                                preferredStyle: .alert)
    
    remainMoneySetAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
    
    remainMoneySetAlert.addTextField(configurationHandler:{(textField: UITextField) -> Void in
      textField.placeholder = "金額を入力してください"
      textField.delegate = self
      textField.keyboardType = UIKeyboardType.numberPad
      
      remainMoneySetAlert.addAction(UIAlertAction(title: "決定", style: .default, handler:{ action in
        if textField.text != ""{
          if self.segnum == 0{
            self.dvc.SaveOneMonthMoneyResult.set(Int(textField.text!), forKey: "SaveMoney")
            let viewRemain = self.method.CommaAdd(comma: self.dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
            self.oneMonthMoneyRemain.text =  viewRemain
          }else{
            self.vc.remainResult.set(Int(textField.text!), forKey: "remain")
            self.oneMonthMoneyRemain.text = self.method.CommaAdd(comma: ViewController().remainResult.integer(forKey: "remain"))
          }
         
        }
      } ))
    } )
    self.present(remainMoneySetAlert, animated: true, completion: nil)
  }
  
  @IBOutlet weak var itemTitle: UILabel!
  
  
  func remainMoneyViewSet(){
    itemTitle.text! = "残りの使える金額"
    oneMonthMoneyRemain.text! = method.CommaAdd(comma: dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
    setButtonTitle.setTitle("残りの金額を設定", for: .normal)
    segnum = 0
  }
  
  func poolMoneyViewSet(){
    itemTitle.text! = "貯められた金額"
    oneMonthMoneyRemain.text! = method.CommaAdd(comma: ViewController().remainResult.integer(forKey: "remain"))
    setButtonTitle.setTitle("貯められた金額を設定", for: .normal)
    segnum = 1
  }
  
  var segnum = 0
  
  @IBOutlet weak var setButtonTitle: UIButton!
  
  @IBAction func changeSegment(_ sender: UISegmentedControl) {
    switch  sender.selectedSegmentIndex {
    case 0:
      remainMoneyViewSet()
      
    case 1:
      poolMoneyViewSet()
    
    default:
      print("error")
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

extension resultViewController: MyTabBarDelegate {

  func didSelectTab(tabBarController: UITabBarController) {
    ontap()
  }
}


