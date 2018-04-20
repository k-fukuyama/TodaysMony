//
//  ViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/03/11.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import Foundation

class ViewController: UIViewController, UITextFieldDelegate{
  
  let ud = UserDefaults.standard
  let udtwo = UserDefaults()
  let ud3 = UserDefaults.standard
  let ud4 = UserDefaults()
  var poolmony = 0
  var returnnum = 0
  var poolmonytwo = 0

  @IBOutlet weak var resultmony: MBCircularProgressBarView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   UsedMony.tag = 1
   MonyField.tag = 2
    
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.groupingSeparator = ","
    formatter.groupingSize = 3
    
    UpsideToolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    UpsideToolBar.shadowImage(forToolbarPosition: .any)
    UpsideToolBar.isTranslucent = true
    
    self.navigationController?.setToolbarHidden(false, animated: false)
    
    let button = UIBarButtonItem(barButtonHiddenItem: .Down, target: nil, action: #selector(ViewController.buttonEvent(sender:)))
    
    button.tintColor = UIColor.yellow
    
    self.UpsideToolBar.setItems([button], animated: true)
    
    var used = Used()

    MonyField.delegate = self
    UsedMony.delegate = self
    UsedMony.returnKeyType = .done
    self.MonyField.keyboardType = UIKeyboardType.numberPad
    self.UsedMony.keyboardType = UIKeyboardType.numberPad
    MonyField.placeholder = "今日使っていい金額"
    UsedMony.placeholder = "使った金額"
    
    let toolbar = UIToolbar()
    toolbar.barStyle = UIBarStyle.default
    toolbar.sizeToFit()
    
    let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
    
    let commitbutton = UIBarButtonItem(title:"決定", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.commit))
    
    toolbar.items = [spacer, commitbutton]
    
    let UsedCostToolbar = UIToolbar()
    UsedCostToolbar.barStyle = UIBarStyle.default
    UsedCostToolbar.sizeToFit()
    
    let DecideButton = UIBarButtonItem(title: "決定", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.UsedMonyButton))
    
    UsedCostToolbar.items = [spacer, DecideButton]
    
    MonyField.inputAccessoryView = toolbar
    UsedMony.inputAccessoryView = UsedCostToolbar
    
    
    if ud.integer(forKey: "mony") != nil{
      TodayMonyNum = ud.integer(forKey: "mony")
      TodayMony.text = "¥\(formatter.string(from: ud.integer(forKey: "mony") as NSNumber )! )"
    }
    
    
    if poolmonytwo == 0{
      
      poolmonytwo = udtwo.integer(forKey: "poolmonytwo")
      udtwo.set(poolmonytwo, forKey: "poolmonytwo")
      udtwo.synchronize()
      
      print("\(poolmonytwo)現状")
      
    }else{
      udtwo.set(poolmonytwo, forKey: "poolmonytwo")
      poolmonytwo = ud.integer(forKey: "poolmonytwo")
      udtwo.synchronize()
      print("お金ありません")
    }
    
    if ud3.float(forKey: "resultmonyyy") != nil{
      resultmony.value = CGFloat(ud3.float(forKey: "resultmonyyy"))
      
    }else{
      resultmony.value = 100
    }
    
    
    
    print("\(udtwo.integer(forKey: "poolmonytwo"))です")
    print(ud.integer(forKey: "mony"))
  
    if zyunresult == 0{
      zyunresult = ud.integer(forKey: "mony")
    }
    if zyunresult < ud4.integer(forKey: "mony2") / 2{
      self.resultmony.progressColor = UIColor.red
      self.resultmony.progressStrokeColor = UIColor.red
    }else if zyunresult > ud4.integer(forKey: "mony2") / 2{
      self.resultmony.progressColor = UIColor.yellow
      self.resultmony.progressStrokeColor = UIColor.yellow
    }
    
    print("マニー2は\(ud4.integer(forKey: "mony2"))")
    print("順れざるとは\(zyunresult)")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func buttonEvent(sender: Any) {
    if self.suzi == 1{
      UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
        self.UsedMony.center.y += 20
      })
      suzi = 0
    }
    UsedMony.endEditing(true)
    
    
    let SubButtonAlert = UIAlertController(title: nil,
                                           message: "",
                                           preferredStyle: .actionSheet)
    
    SubButtonAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
    
    SubButtonAlert.addAction(UIAlertAction(title: "1ヶ月、自由に使える金額計算", style: .default, handler: { action in
      let OneMonthMony = UIAlertController(title: "今月自由に使える金額を入力してください",
                                           message: "[入力した金額]÷31日で1日あたりに使える金額を計算します",
                                           preferredStyle: .alert
                                           )
      
      
      OneMonthMony.addTextField(configurationHandler: {(textField: UITextField) -> Void in
        
        
        
       
        textField.placeholder = "お給料を入力してください"
        textField.delegate = self
        textField.keyboardType  = UIKeyboardType.numberPad
       
        
        OneMonthMony.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
          
          if textField.text != "" {
           

            let OndDayMony = Int(textField.text!)! / 31
            let OndDayMonyAlert = UIAlertController(title: "¥\(OndDayMony)",
              message: "が1日あたりの使用可能金額です",
              preferredStyle: .alert)
            
            
            
            OndDayMonyAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(OndDayMonyAlert, animated:true, completion:nil)
            
           
            
            
          }
        }))
        
    self.present(OneMonthMony, animated: true, completion: nil)
      } )
      
    }))
    
    SubButtonAlert.addAction(UIAlertAction(title: "細かく計算する", style: .default, handler :{ action in
      self.performSegue(withIdentifier: "detail", sender: nil)
    }))
    
    self.present(SubButtonAlert, animated: true, completion: nil)
    
    
  }
  
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    
    if suzi == 1{
      UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
        self.UsedMony.center.y += 20
      })
    }
    suzi = 0
  }
  
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 7
    var str = textField.text! + string
    
    if str.characters.count < maxLength{
      return true
    }
    
    return false
    
  }
  
  var suzi = 0
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField.tag == 1{
      UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
                self.UsedMony.center.y -= 20
      })
      
      suzi = 1
      
    }else if textField.tag == 2{
      if suzi == 1{
        UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
                self.UsedMony.center.y += 20
              })
      }
      suzi = 0
    }
  }
  
  
  
  var TodayMonyNum = 0
  
  @objc func commit(){
    if MonyField.text != ""{
      TodayMonyNum = Int(MonyField.text!)!
      switch TodayMonyNum{
      case 0:
        var zeroalert = UIAlertController(
          title: "0円は設定できません",
          message: "金額を設定しないとアプリが使用できません",
          preferredStyle: .alert)
         MonyField.endEditing(true)
        
        
        zeroalert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(zeroalert, animated: true, completion: nil)
    
      default:
        UIView.animate(withDuration: 1.3) {
          self.resultmony.value = 100
          self.resultmony.progressColor = UIColor.yellow
          self.resultmony.progressStrokeColor = UIColor.yellow
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        ud3.set(resultmony.value, forKey: "resultmonyyy")
        TodayMony.text = "¥\(formatter.string(from: Int(MonyField.text!) as! NSNumber)!)"
        TodayMonyNum = Int(MonyField.text!)!
        ud.set(TodayMonyNum, forKey: "mony")
        ud4.set(TodayMonyNum, forKey: "mony2")
        MonyField.endEditing(true)
        MonyField.text = ""
      }
      
    }else{
      
      MonyField.endEditing(true)
      MonyField.text = ""
      
    }
  }
  
  @objc func UsedMonyButton(){
    if UsedMony.text != ""{
      
      if ud.integer(forKey: "mony") != nil{
        
        print(ud.integer(forKey: "mony"))
        
        BeNum = UsedMony.text!
        Todayusedmony = Int(BeNum)!
        
        bbb = float_t(Todayusedmony) / float_t(ud4.integer(forKey: "mony2"))
        
        
        UIView.animate(withDuration: 1.3){
          if self.resultmony.value != 0{
            self.resultmony.value = CGFloat(float_t(self.Todayusedmony) / float_t(self.ud4.integer(forKey: "mony2")))
            
          }else{
            self.resultmony.value = 0
          }
          
          
        }
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        zyunresult = ud.integer(forKey: "mony") - Todayusedmony
        TodayMony.text = "¥\(formatter.string(from: zyunresult as NSNumber)! )"
        
        ud.set(zyunresult, forKey: "mony")
        ud.synchronize()
        UsedMony.endEditing(true)
        suzi = 0
        
        if zyunresult < ud4.integer(forKey: "mony2") / 2{
          self.resultmony.progressColor = UIColor.red
          self.resultmony.progressStrokeColor = UIColor.red
        }
        
        UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
                self.UsedMony.center.y += 20
              })
        suzi = 0
        
        UsedMony.text = ""
        
      }else{
        BeNum = UsedMony.text!
        Todayusedmony = Int(BeNum)!
        
        bbb = float_t(float_t(Todayusedmony) / float_t(ud4.integer(forKey: "mony2")) * 100)
        resultmony.value = CGFloat(bbb)
        
        ud3.set(resultmony.value, forKey: "resultmonyyy")
        ud3.synchronize()
        
        
        zyunresult = TodayMonyNum - Todayusedmony
        TodayMony.text = String(zyunresult)
        
        ud.set(zyunresult, forKey: "mony")
        ud.synchronize()
        UsedMony.endEditing(true)
        
        suzi = 0
        UsedMony.text = ""
      }
      
      if ud3.float(forKey: "resulymonyyy") != nil{
        
        resultmony.value = CGFloat(ud3.float(forKey: "resultmonyyy") - bbb * 100)
        
        ud3.set(resultmony.value, forKey: "resultmonyyy")
        ud3.synchronize()
      }else{
        resultmony.value = CGFloat(float_t(100) - bbb * 100)
        
        ud3.set(resultmony.value, forKey: "resultmonyyy")
        ud3.synchronize()
        UsedMony.endEditing(true)
        suzi = 0
      }
      
      
      
    }else{
      UsedMony.endEditing(true)
      UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
              self.UsedMony.center.y += 20
            })
      suzi = 0
    }
    suzi = 0
  }
  
  @IBOutlet weak var TodayMony: UILabel!
  @IBOutlet weak var MonyField: UITextField!
  
  
  @IBOutlet weak var UsedMony: UITextField!
  
  var EndMonyJudegeNum = 0
  
  @IBAction func EndTodaysMony(_ sender: Any) {
    let EndTodaysMonyAlert = UIAlertController(title: "¥\(ud.integer(forKey: "mony"))",
                                               message: "が今日の残額でよろしいですか?",
                                               preferredStyle: .alert)
    
    EndTodaysMonyAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
      self.EndMonyJudegeNum = 1
      self.performSegue(withIdentifier: "resultmony", sender: nil)
    }))
    EndTodaysMonyAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
    
    self.present(EndTodaysMonyAlert, animated: true, completion: nil)
  }
  
  var Todayusedmony:Int = 0
  var BeNum = ""
  var zyunresult = 0
  var bbb:Float!
  
  var alert:UIAlertController!
  
  @IBAction func move(_ sender: Any) {
    performSegue(withIdentifier: "testmony", sender: nil)
  }
  
  override func prepare(for segue:UIStoryboardSegue, sender:Any?){
    if (segue.identifier == "resultmony"){
        let resultViewController:resultViewController = segue.destination as! resultViewController
        var result = ud.integer(forKey: "mony")
        resultViewController.result = result
      
    }
  }
  
  
  @IBOutlet weak var UpsideToolBar: UIToolbar!
  
  
  
  
}

extension UIBarButtonItem {
  enum HiddenItem: Int {
    case Arrow = 100
    case Back = 101
    case Forward = 102
    case Up = 103
    case Down = 104
  }
  
  convenience init(barButtonHiddenItem: HiddenItem, target: AnyObject?, action: Selector?) {
    let systemItem = UIBarButtonSystemItem(rawValue: barButtonHiddenItem.rawValue)
    self.init(barButtonSystemItem: systemItem!, target: target, action: action)
  }
  
  
}

extension UITextField{
  override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    return false
  }
}
