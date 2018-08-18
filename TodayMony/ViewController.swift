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
  @IBOutlet weak var ResultMoneyButtom: NSLayoutConstraint!
  
  @IBOutlet weak var tabBar: UITabBar!
  
  let ud = UserDefaults.standard
  let udtwo = UserDefaults()
  let ud3 = UserDefaults.standard
  let ud4 = UserDefaults()
  let onepushud = UserDefaults()
  var JudgeOnepush = UserDefaults()
  let TodaysTotalUsedMoney = UserDefaults()
  var poolmony = 0
  var returnnum = 0
  var poolmonytwo = 0
  var SentOneDayMoney = 0

  @IBOutlet weak var resultmony: MBCircularProgressBarView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print( UIScreen.main.nativeBounds.size)
    
    
    
    
    if UIScreen.main.nativeBounds.size.width >= 750.0{
      ResultMoneyButtom.constant = 1
      TodayMony.font = UIFont.systemFont(ofSize: 45)
    }else{
      ResultMoneyButtom.constant = 5
    }
    
    print(ResultMoneyButtom.constant)
    
    
    
    let notificationcenter = NotificationCenter.default
    
    notificationcenter.addObserver(self, selector: #selector(showkeyboard(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    
    print("今日使った金額は\(TodaysTotalUsedMoney.integer(forKey: "TodaysTotalUd"))")
    
   UsedMony.tag = 1
   MonyField.tag = 2
    
    
    UpsideToolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    UpsideToolBar.shadowImage(forToolbarPosition: .any)
    UpsideToolBar.isTranslucent = true
    
    self.navigationController?.setToolbarHidden(false, animated: false)
    
    let button = UIBarButtonItem(barButtonHiddenItem: .Down, target: nil, action: #selector(ViewController.buttonEvent(sender:)))
    
    button.tintColor = UIColor.yellow
    
    self.UpsideToolBar.setItems([button], animated: true)
    

    MonyField.delegate = self
    UsedMony.delegate = self
    UsedMony.returnKeyType = .done
    self.MonyField.keyboardType = UIKeyboardType.numberPad
    self.UsedMony.keyboardType = UIKeyboardType.numberPad
    MonyField.placeholder = "今日使える金額"
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
      TodayMony.text = CommaAdd(comma: ud.integer(forKey: "mony"))
    }else{
      TodayMonyNum = ud.integer(forKey: "mony")
      TodayMony.text = CommaAdd(comma: ud.integer(forKey: "mony"))
    }
    
    
    if poolmonytwo == 0{
      
      poolmonytwo = udtwo.integer(forKey: "poolmonytwo")
      udtwo.set(poolmonytwo, forKey: "poolmonytwo")
      udtwo.synchronize()
      
    }else{
      udtwo.set(poolmonytwo, forKey: "poolmonytwo")
      poolmonytwo = ud.integer(forKey: "poolmonytwo")
      udtwo.synchronize()
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
      self.resultmony.progressStrokeColor = UIColor.yellow;#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
    }
    
    if SentOneDayMoney != 0{
      onepushud.set(SentOneDayMoney, forKey: "onepushmony")
      onepushud.synchronize()
    }
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
    
    SubButtonAlert.addAction(UIAlertAction(title: "1日あたりに使える金額計算", style: .default, handler: { action in
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
    
    SubButtonAlert.addAction(UIAlertAction(title: "1ヶ月あたりに使える金額計算", style: .default, handler :{ action in
      self.performSegue(withIdentifier: "detail", sender: nil)
    }))
    
    SubButtonAlert.addAction(UIAlertAction(title: "1Push入力金額設定", style: .default, handler :{ action in
      let onepush = UIAlertController(title: "1Pushで設定したい金額を入力してください",
                                      message: "ボタン一つで金額を設定できるようになります",
                                      preferredStyle: .alert)
      
      onepush.addTextField(configurationHandler:{(textField:UITextField) -> Void in
        textField.placeholder = "1pushで入力する金額を設定してください"
        textField.delegate = self
        textField.keyboardType  = UIKeyboardType.numberPad
        
        onepush.addAction(UIAlertAction(title: "決定", style: .default, handler:{ action in
          if textField.text != "" {
            let benum = Int(textField.text!)
            self.onepushud.set(benum, forKey: "onepushmony")
            self.onepushud.synchronize()
            
            let onepushalert = UIAlertController(title: "設定完了",
                                                 message: "金額を設定できました",
                                                 preferredStyle: .alert)
            
            onepushalert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(onepushalert, animated: true, completion: nil)
          }
        }))
      })
      self.present(onepush, animated: true, completion: nil)
    }))
    
    
    self.present(SubButtonAlert, animated: true, completion: nil)
    
  }
  
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    
    if suzi == 1{
      UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
        self.UsedMony.center.y += 20
      })
      suzi = 0
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
  
  var suzi = 0
  
  var KeyboardHighResult = 0
  
  @objc func showkeyboard(notification:Notification){
    if let userinfo = notification.userInfo{
      if let keyboard = userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
        let keyhigh = keyboard.cgRectValue
        KeyboardHighResult = Int(keyhigh.size.height)
        if KeyboardHighResult > 260 && suzi == 0{
          UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
            self.UsedMony.center.y -= 20
            self.suzi = 1
            print(self.suzi)
          })
        }else{
          print("kuriyama")
        }
      }
    }
  }
  
  
//  func textFieldDidBeginEditing(_ textField: UITextField) {
//    print("\(KeyboardHighResult)わああわあわあ")
//    if textField.tag == 1{
//      UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
//                self.UsedMony.center.y -= 20
//      })
//
//      suzi = 1
//
//    }else if textField.tag == 2{
//      if suzi == 1{
//        UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
//                self.UsedMony.center.y += 20
//              })
//      }
//      suzi = 0
//    }
//  }
  
  
  
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
        if suzi == 1{
          UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
            self.UsedMony.center.y += 20
          })
          suzi = 0
          print("これがああああああ\(suzi)")
        }
         MonyField.endEditing(true)
        
        
        
        zeroalert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(zeroalert, animated: true, completion: nil)
    
      default:
        UIView.animate(withDuration: 1.3) {
          self.resultmony.value = 100
          self.resultmony.progressColor = UIColor.yellow
          self.resultmony.progressStrokeColor = UIColor.yellow
        }
        
        
        if suzi == 1{
          UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
            self.UsedMony.center.y += 20
          })
          suzi = 0
          print("これがああああああ\(suzi)")
        }
        TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
        ud3.set(resultmony.value, forKey: "resultmonyyy")
        
        TodayMony.text = CommaAdd(comma: Int(MonyField.text!)!)
        TodayMonyNum = Int(MonyField.text!)!
        ud.set(TodayMonyNum, forKey: "mony")
        ud4.set(TodayMonyNum, forKey: "mony2")
        MonyField.endEditing(true)
        MonyField.text = ""
      }
      
    }else{
      
      if suzi == 1{
        UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
          self.UsedMony.center.y += 20
        })
        MonyField.endEditing(true)
        MonyField.text = ""
        suzi = 0
      }else{
        MonyField.endEditing(true)
        MonyField.text = ""
      }
      
      
    }
  }
  
  func CommaAdd(comma:Int) -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.groupingSeparator = ","
    formatter.groupingSize = 3

    let becomma = "¥\(formatter.string(from: Int(comma) as! NSNumber)!)"

    return becomma

  }
  
  @IBAction func OnePushButton(_ sender: Any) {
    
    if JudgeOnepush.integer(forKey: "judgenum") == 0{
      
      
      UIView.animate(withDuration: 1.3) {
        self.resultmony.value = 100
        self.resultmony.progressColor = UIColor.yellow
        self.resultmony.progressStrokeColor = UIColor.yellow
        
      }
      
      var onepush = onepushud.integer(forKey: "onepushmony")
      ud3.set(resultmony.value, forKey: "resultmonyyy")
      
      TodayMony.text = CommaAdd(comma: onepush)
      
      ud.set(onepush, forKey: "mony")
      ud4.set(onepush, forKey: "mony2")
      TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
      
    }else{
      let OnepushDoneAlert = UIAlertController(
      title: "既に1pushを押しています",
      message: "もう一度設定しますか？",
      preferredStyle: .alert)
      
      OnepushDoneAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        
        UIView.animate(withDuration: 1.3) {
          self.resultmony.value = 100
          self.resultmony.progressColor = UIColor.yellow
          self.resultmony.progressStrokeColor = UIColor.yellow
          
        }
        
        var onepush = self.onepushud.integer(forKey: "onepushmony")
        self.ud3.set(self.resultmony.value, forKey: "resultmonyyy")
        
        self.TodayMony.text = self.CommaAdd(comma: onepush)
        
        self.ud.set(onepush, forKey: "mony")
        self.ud4.set(onepush, forKey: "mony2")
        
      }))
      OnepushDoneAlert.addAction(UIAlertAction(title: "キャンセル", style: .default))
      present(OnepushDoneAlert, animated: true, completion: nil)
    }
    JudgeOnepush.set(1, forKey: "judgenum")
    TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
  }
  
  
  @objc func UsedMonyButton(){
    if UsedMony.text != ""{
      
      if ud.integer(forKey: "mony") != nil{
        
        print(ud.integer(forKey: "mony"))
        
        BeNum = UsedMony.text!
        Todayusedmony = Int(BeNum)!
        
        bbb = float_t(Todayusedmony) / float_t(ud4.integer(forKey: "mony2"))
        
        var total = Todayusedmony + TodaysTotalUsedMoney.integer(forKey: "TodaysTotalUd")
        
        TodaysTotalUsedMoney.set(total, forKey: "TodaysTotalUd")
        
        
        UIView.animate(withDuration: 1.3){
          if self.resultmony.value != 0{
            self.resultmony.value = CGFloat(float_t(self.Todayusedmony) / float_t(self.ud4.integer(forKey: "mony2")))
            
          }else{
            self.resultmony.value = 0
          }
          
          
        }
        
        zyunresult = ud.integer(forKey: "mony") - Todayusedmony
        TodayMony.text = CommaAdd(comma: zyunresult)

        ud.set(zyunresult, forKey: "mony")
        ud.synchronize()
        UsedMony.endEditing(true)
        
        
        if zyunresult < ud4.integer(forKey: "mony2") / 2{
          self.resultmony.progressColor = UIColor.red
          self.resultmony.progressStrokeColor = UIColor.red
        }
        
        if suzi == 1{
          UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
            self.UsedMony.center.y += 20
          })
          suzi = 0
        }
        
        suzi = 1
        
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
      if suzi == 1{
        UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
          self.UsedMony.center.y += 20
        })
        suzi = 0
      }
      
    }
    suzi = 0
  }
  
  @IBOutlet weak var TodayMony: UILabel!
  @IBOutlet weak var MonyField: UITextField!
  
  
  @IBOutlet weak var UsedMony: UITextField!
  
  var EndMonyJudegeNum = 0
  
  var todaysOneMonethMoneyRemain = 0
  
  @IBAction func EndTodaysMony(_ sender: Any) {
    let EndTodaysMonyAlert = UIAlertController(title: "¥\(ud.integer(forKey: "mony"))",
                                               message: "が今日の残額でよろしいですか?",
                                               preferredStyle: .alert)
   
    
    EndTodaysMonyAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
//      self.EndMonyJudegeNum = 1
      self.JudgeOnepush.set(0, forKey: "judgenum")
//      let dvc = detailmonyViewController()
//      let totalResult = dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney") - self.TodaysTotalUsedMoney.integer(forKey: "TodaysTotalUd")
//      dvc.SaveOneMonthMoneyResult.set(totalResult, forKey: "SaveMoney")
//
      let rvc = resultViewController()
      let dvc = detailmonyViewController()
      self.todaysOneMonethMoneyRemain = dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney") - self.TodaysTotalUsedMoney.integer(forKey: "TodaysTotalUd")
      dvc.SaveOneMonthMoneyResult.set(self.todaysOneMonethMoneyRemain, forKey: "SaveMoney")
      
      let todaysResult = UIAlertController(title: "今月残り使える金額は\(self.todaysOneMonethMoneyRemain)円です",
        message: "",
        preferredStyle: .alert)
      todaysResult.addAction(UIAlertAction(title: "OK", style: .destructive))
      self.present(todaysResult, animated: true, completion: nil)
      self.TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
      
    }))
    
    
    
    EndTodaysMonyAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler :{ action in
      if self.suzi == 1{
        UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
          self.UsedMony.center.y += 20
        })
      }
    }))
    
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
  
//  override func prepare(for segue:UIStoryboardSegue, sender:Any?){
//    if (segue.identifier == "resultmoney"){
////        let resultViewController:resultViewController = segue.destination as! resultViewController
////        var result = ud.integer(forKey: "mony")
////        resultViewController.result = result
////        resultViewController.SegueUsedMoney = TodaysTotalUsedMoney.integer(forKey: "TodaysTotalUd")
////        TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
//      self.tabBarController?.selectedIndex = 2
//
//    }
//  }
  
  
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
