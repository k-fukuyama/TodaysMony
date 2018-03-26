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
  var poolmonytwo = 1

  @IBOutlet weak var resultmony: MBCircularProgressBarView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    MonyField.delegate = self
    UsedMony.delegate = self
    UsedMony.returnKeyType = .done
    self.MonyField.keyboardType = UIKeyboardType.numberPad
    self.UsedMony.keyboardType = UIKeyboardType.numberPad
    
    let toolbar = UIToolbar()
    toolbar.barStyle = UIBarStyle.default
    toolbar.sizeToFit()
    
    let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
    
    let commitbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.commit))
    
    toolbar.items = [spacer, commitbutton]
    
    MonyField.inputAccessoryView = toolbar
    UsedMony.inputAccessoryView = toolbar
    
    
    if ud.integer(forKey: "mony") != nil{
      TodayMonyNum = ud.integer(forKey: "mony")
      TodayMony.text = "\(ud.integer(forKey: "mony"))円"
    }
    
    
    if poolmonytwo == 1{
      
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
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  @objc func commit(){
    MonyField.endEditing(true)
    UsedMony.endEditing(true)
  }
  
  @IBOutlet weak var TodayMony: UILabel!
  @IBOutlet weak var MonyField: UITextField!
  
  var TodayMonyNum = 0
  
  @IBAction func DoneCost(_ sender: Any) {
    
   
    
    if MonyField.text != ""{
      UIView.animate(withDuration: 1.3){
        self.resultmony.value = 100
      }
      ud3.set(resultmony.value, forKey: "resultmonyyy")
      TodayMony.text = "\(MonyField.text!)円"
      TodayMonyNum = Int(MonyField.text!)!
      ud.set(TodayMonyNum, forKey: "mony")
      ud4.set(TodayMonyNum, forKey: "mony2")
    }else{
      var emptyalert = UIAlertController(
        title: "今日の金額を入力してください",
        message: "金額を設定しないとアプリが使用できません",
        preferredStyle: .alert)
      
      emptyalert.addAction(UIAlertAction(title: "OK", style: .cancel))
      
      self.present(emptyalert, animated: true, completion: nil)
    }
    
    
    
  }
  
  @IBOutlet weak var UsedMony: UITextField!
  
  var Todayusedmony:Int = 0
  var BeNum = ""
  var zyunresult = 0
  var bbb:Float!
  
  @IBAction func ResultMony(_ sender: Any) {
    
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
        
        zyunresult = ud.integer(forKey: "mony") - Todayusedmony
        TodayMony.text = "\(String(zyunresult))円"
        
        ud.set(zyunresult, forKey: "mony")
        ud.synchronize()
        
        
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
        
      }
      
      if ud3.float(forKey: "resulymonyyy") != nil{
        
        resultmony.value = CGFloat(ud3.float(forKey: "resultmonyyy") - bbb * 100)
        
        ud3.set(resultmony.value, forKey: "resultmonyyy")
        ud3.synchronize()
      }else{
        resultmony.value = CGFloat(float_t(100) - bbb * 100)
        
        ud3.set(resultmony.value, forKey: "resultmonyyy")
        ud3.synchronize()
      }
      
      
      
    }else{
      
      var emptyalert = UIAlertController(
        title: "使用金額を入力してください",
        message: "使用した金額を入力しないとアプリが使用できません",
        preferredStyle: .alert)
      
      emptyalert.addAction(UIAlertAction(title: "OK", style: .cancel))
      
      self.present(emptyalert, animated: true, completion:  nil)
      
    }
    
   
    
   
   
  }
  
  var alert:UIAlertController!
  
  @IBAction func kessan(_ sender: Any) {
    alert = UIAlertController(
      title: "決算しますか?",
      message:"本日の決算に移ります",
      preferredStyle: .actionSheet
    )
    
    alert.addAction(UIAlertAction(title:"決算", style: .destructive, handler: { action in
      self.performSegue(withIdentifier: "resultmony", sender: nil)
    }))
    
    alert.addAction(UIAlertAction(title:"決算をやめる", style:.cancel))
    
    self.present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func move(_ sender: Any) {
    performSegue(withIdentifier: "pool", sender: nil)
  }
  
  override func prepare(for segue:UIStoryboardSegue, sender:Any?){
    if (segue.identifier == "resultmony"){
      let resultViewController:resultViewController = segue.destination as! resultViewController
      var result = ud.integer(forKey: "mony")
      resultViewController.result = result
    }else if (segue.identifier == "pool"){
      let pvc:poolViewController = segue.destination as! poolViewController
      pvc.poolmony = poolmonytwo
    }
  }
  
  @IBAction func OneMonthMony(_ sender: Any) {
    let alert = UIAlertController(title: "1日あたりに使っていい金額を計算します",
                                  message: "手取り額を入力しましょう",
                                  preferredStyle: .alert)
    
    alert.addTextField(configurationHandler: {(textField: UITextField! ) -> Void in
      textField.placeholder = "お給料を入力してください"
      textField.delegate = self
      textField.keyboardType  = UIKeyboardType.numberPad
      
      alert.addAction(UIAlertAction(title:"OK", style: .destructive, handler: { action in
        if textField.text != ""{
          
          var ans = Int(textField.text!)! / 31
          let alert = UIAlertController(title: "\(ans)円",
                                        message: "が1日あたりの使用可能金額です",
                                        preferredStyle: .alert)
          
          alert.addAction(UIAlertAction(title:"OK", style: .cancel))
          self.present(alert, animated: true, completion: nil)
        }
      }))
    
    self.present(alert, animated: true, completion:  nil)
    
      
      
    })
  }
  
  
}
