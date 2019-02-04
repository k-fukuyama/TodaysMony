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
  let want_goods_cost = UserDefaults()

  
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
  var textNum = 0
  
  @IBAction func reset(_ sender: Any) {
    var remain_alert = UIAlertController(title:"残りの金額をリセット",
                                  message:"残りの金額をリセットします",
                                  preferredStyle: .alert)
    
    let next_salary_alert = UIAlertController(title:"次の給料日まで",
                                             message:"次の給料日までの日数をに入力してください",
                                             preferredStyle: .alert)
    
    
    if segnum == 0{
      
      next_salary_alert.addTextField(configurationHandler: {(textField: UITextField) -> Void in
        
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.numberPad
        textField.tag = 1
        self.textNum = textField.tag
        

          next_salary_alert.addAction(UIAlertAction(title: "決定", style: .default, handler:{ action in
            if textField.text != "" && Int(textField.text!) != 0{
                        let while_next_salary_one_day_cost = UIAlertController(title: "\(self.dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney") / Int(textField.text!)!)円",
                          message: "が残りの使える金額です",
                          preferredStyle: .alert)
              while_next_salary_one_day_cost.addAction(UIAlertAction(title:"Ok", style: .default))
              self.present(while_next_salary_one_day_cost, animated: true, completion: nil)
            }
          }))
          
        
        self.present(next_salary_alert, animated: true, completion: nil)
      })
    }else{
      remain_alert.addAction(UIAlertAction(title:"リセットする", style:.destructive, handler:{ action in
        if self.segnum == 1{
          self.vc.remainResult.removeObject(forKey: "remain")
          self.vc.firstEnd.removeObject(forKey: "endCount")
          self.oneMonthMoneyRemain.text! = self.method.CommaAdd(comma: self.vc.remainResult.integer(forKey: "remain"))
        }else{
          self.want_goods_cost.removeObject(forKey: "wants")
          self.oneMonthMoneyRemain.text! = self.method.CommaAdd(comma: self.want_goods_cost.integer(forKey: "wants"))
        }
        
      }))
    }
    
    remain_alert.addAction(UIAlertAction(title:"リセットしない", style: .cancel))
    
    
  }
  
  
  
  
  func ontap(){
    if segnum == 0{
      oneMonthMoneyRemain.text! = method.CommaAdd(comma: dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
    }else if segnum == 1{
      oneMonthMoneyRemain.text! = method.CommaAdd(comma: ViewController().remainResult.integer(forKey: "remain"))
    }else{
      oneMonthMoneyRemain.text! = method.CommaAdd(comma: self.want_goods_cost.integer(forKey: "wants"))
    }
    
    
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textNum == 1{
      let maxLength = 3
      var str = textField.text! + string
      
      if str.characters.count < maxLength{
        return true
      }
      
      return false
    }else{
      let maxLength = 7
      var str = textField.text! + string
      
      if str.characters.count < maxLength{
        return true
      }
      
      return false
    }
    
    
  }
  
  
  
  @IBAction func remainMoneySetButton(_ sender: Any) {
    let remainSetTitle = "残りの金額を設定します"
    let poolMoneySetTitle = "貯められた金額を修正します"
    var title = ""
    
    if segnum == 0{
      title = remainSetTitle
    }else if segnum == 1{
      title = poolMoneySetTitle
    }else{
      title = "欲しいものの金額を入力します"
    }
    let remainMoneySetAlert = UIAlertController(title: title,
                                                message: "金額を入力してください",
                                                preferredStyle: .alert)
    
    remainMoneySetAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
    
    remainMoneySetAlert.addTextField(configurationHandler:{(textField: UITextField) -> Void in
      textField.tag = 2
      self.textNum = textField.tag
      textField.placeholder = "金額を入力してください"
      textField.delegate = self
      textField.keyboardType = UIKeyboardType.numberPad
      
      remainMoneySetAlert.addAction(UIAlertAction(title: "決定", style: .default, handler:{ action in
        if textField.text != ""{
          if self.segnum == 0{
            self.dvc.SaveOneMonthMoneyResult.set(Int(textField.text!), forKey: "SaveMoney")
            let viewRemain = self.method.CommaAdd(comma: self.dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
            self.oneMonthMoneyRemain.text =  viewRemain
          }else if self.segnum == 1{
            self.vc.remainResult.set(Int(textField.text!), forKey: "remain")
            self.oneMonthMoneyRemain.text = self.method.CommaAdd(comma: ViewController().remainResult.integer(forKey: "remain"))
          }else{
            self.want_goods_cost.set(Int(textField.text!), forKey: "wants")
            self.oneMonthMoneyRemain.text = self.method.CommaAdd(comma: self.want_goods_cost.integer(forKey: "wants"))
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
  
  func wantsSet(){
    itemTitle.text! = "欲しいものの金額"
    oneMonthMoneyRemain.text! = method.CommaAdd(comma: self.want_goods_cost.integer(forKey: "wants"))
    setButtonTitle.setTitle("欲しいものの金額", for: .normal)
    segnum = 2
  }
  
  func want_goods(){
    itemTitle.text! = "欲しいものが買えるまで"
    setButtonTitle.setTitle("欲しいものの金額", for: .normal)
    segnum = 2
  }
  
  var segnum = 0
  
  @IBOutlet weak var setButtonTitle: UIButton!
  
  @IBAction func changeSegment(_ sender: UISegmentedControl) {
    switch  sender.selectedSegmentIndex {
    case 0:
      remainMoneyViewSet()
      
    case 1:
      poolMoneyViewSet()
      
    case 2:
      wantsSet()
    
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


