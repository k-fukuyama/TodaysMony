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
  
  @IBOutlet weak var onePushBottom: NSLayoutConstraint!
  @IBOutlet weak var tabBar: UITabBar!
  @IBOutlet weak var resultViewTop: NSLayoutConstraint!
  
  let ud = UserDefaults.standard
  let udtwo = UserDefaults()
  let ud3 = UserDefaults.standard
  let ud4 = UserDefaults()
  let onepushud = UserDefaults()
  var JudgeOnepush = UserDefaults()
  let TodaysTotalUsedMoney = UserDefaults()
  let todaysUsedLog = UserDefaults()
  let todaysUsedTime = UserDefaults()
  let hashLog = UserDefaults()
  var poolmony = 0
  var returnnum = 0
  var poolmonytwo = 0
  let method = MethodStruct()

  @IBOutlet weak var resultmony: MBCircularProgressBarView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
    print(UsedMony.frame.origin.y)
    
    print( UIScreen.main.nativeBounds.size.width)
    percentSet()
    
    
    if UIScreen.main.nativeBounds.size.width < 750.0{
      ResultMoneyButtom.constant = 1
      onePushBottom.constant = 35
    }else if UIScreen.main.nativeBounds.size.width >= 828.0{
      onePushBottom.constant = 80
      TodayMony.font = UIFont.systemFont(ofSize: 50)
      resultViewTop.constant = 30
    }
    
    
    let notificationcenter = NotificationCenter.default
    
    notificationcenter.addObserver(self, selector: #selector(showkeyboard(notification:)), name: .UIKeyboardWillShow, object: nil)
    
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
      TodayMony.text = method.CommaAdd(comma: ud.integer(forKey: "mony"))
    }else{
      TodayMonyNum = ud.integer(forKey: "mony")
      TodayMony.text = method.CommaAdd(comma: ud.integer(forKey: "mony"))
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
    
    
    let onePushData = onepushud.integer(forKey: "onepushmony")
    
    if onePushData != 0{
      onePushTitle.setTitle(method.CommaAdd(comma: onePushData), for: .normal)
    }else{
      onePushTitle.setTitle("1push", for: .normal)
    }
    
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBOutlet weak var onePushTitle: UIButton!
  
  @objc func buttonEvent(sender: Any) {
    if self.suzi == 1{
      UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
        self.UsedMony.center.y += 10
      })
      suzi = 0
    }
    UsedMony.endEditing(true)
    
    
    let SubButtonAlert = UIAlertController(title: nil,
                                           message: nil,
                                           preferredStyle: .actionSheet)
    
    SubButtonAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
    
    SubButtonAlert.addAction(UIAlertAction(title: "1日あたりに使える金額計算", style: .default, handler: { action in
      let OneMonthMony = UIAlertController(title: "今月自由に使える金額を入力してください",
                                           message: "[入力した金額]÷31日で1日あたりに使える金額を計算します",
                                           preferredStyle: .alert
                                           )
      
      
      OneMonthMony.addTextField(configurationHandler: ({(textField: UITextField) -> Void in
        
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
        } as! (UITextField) -> Void) )
      
    }))
    
    SubButtonAlert.addAction(UIAlertAction(title: "1Push入力金額設定", style: .default, handler :{ action in
      let onepush = UIAlertController(title: "1Pushで設定したい金額を入力してください",
                                      message: "ボタン一つで金額を設定できるようになります",
                                      preferredStyle: .alert)
      
      onepush.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
      
      onepush.addTextField(configurationHandler:{(textField:UITextField) -> Void in
        textField.placeholder = "1pushで入力する金額を設定してください"
        textField.delegate = self
        textField.keyboardType  = UIKeyboardType.numberPad
        
        onepush.addAction(UIAlertAction(title: "決定", style: .default, handler:{ action in
          if textField.text != "" {
            let benum = Int(textField.text!)
            self.onepushud.set(benum, forKey: "onepushmony")
            self.onepushud.synchronize()
            let onePushedCost = self.onepushud.integer(forKey: "onepushmony")
            self.onePushTitle.setTitle(self.method.CommaAdd(comma: onePushedCost), for: .normal)
            
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
        self.UsedMony.center.y += 10
      })
      suzi = 0
    }
    NotificationCenter.default.removeObserver(self)
    
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
  
  var keyboardNumber = 0
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField.tag == 1{
      NotificationCenter.default.addObserver(self, selector: #selector(showkeyboard(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    keyboardNumber = textField.tag
  }
  
  @objc func showkeyboard(notification:Notification){
    if let userinfo = notification.userInfo{
      if let keyboard = userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
        let keyhigh = keyboard.cgRectValue
        KeyboardHighResult = Int(keyhigh.size.height)
        if KeyboardHighResult > 260 && suzi == 0 && keyboardNumber == 1 && UIScreen.main.nativeBounds.size.width >= 828.0{
          UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
            self.UsedMony.center.y -= 10
            self.suzi = 1
            print(self.suzi)
          })
        }else{
          print("action is done")
        }
      }
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
        if suzi == 1{
          UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
            self.UsedMony.center.y += 10
          })
          suzi = 0
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
            self.UsedMony.center.y += 10
          })
          suzi = 0
          print("これがああああああ\(suzi)")
        }
        TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
        ud3.set(resultmony.value, forKey: "resultmonyyy")
        
        TodayMony.text = method.CommaAdd(comma: Int(MonyField.text!)!)
        TodayMonyNum = Int(MonyField.text!)!
        ud.set(TodayMonyNum, forKey: "mony")
        ud4.set(TodayMonyNum, forKey: "mony2")
        MonyField.endEditing(true)
        MonyField.text = ""
      }
      JudgeOnepush.set(1, forKey: "judgenum")
    }else{
      
      if suzi == 1{
        UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
          self.UsedMony.center.y += 10
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
  
  
  
  
  
  @IBAction func OnePushButton(_ sender: Any) {
    var onepush = onepushud.integer(forKey: "onepushmony")
    
    if onepush == 0{
        let onepush = UIAlertController(title: "1Pushで設定したい金額を入力してください",
                                        message: "ボタン一つで金額を設定できるようになります",
                                        preferredStyle: .alert)
      onepush.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        onepush.addTextField(configurationHandler:{(textField:UITextField) -> Void in
          textField.placeholder = "1pushで入力する金額を設定してください"
          textField.delegate = self
          textField.keyboardType  = UIKeyboardType.numberPad
          
          onepush.addAction(UIAlertAction(title: "決定", style: .default, handler:{ action in
            if textField.text != "" {
              let benum = Int(textField.text!)
              self.onepushud.set(benum, forKey: "onepushmony")
              self.onepushud.synchronize()
              let onePushedCost = self.onepushud.integer(forKey: "onepushmony")
              self.onePushTitle.setTitle(self.method.CommaAdd(comma: onePushedCost), for: .normal)
              
              
              let onepushalert = UIAlertController(title: "設定完了",
                                                   message: "金額を設定できました",
                                                   preferredStyle: .alert)
              
              onepushalert.addAction(UIAlertAction(title: "OK", style: .default))
              self.JudgeOnepush.set(0, forKey: "judgenum")
              
              self.present(onepushalert, animated: true, completion: nil)
            }
          }))
        })
        self.present(onepush, animated: true, completion: nil)
      
    }
    
    
    func onePushedNotice(){
      
      let OnepushDoneAlert = UIAlertController(
        title: "既に金額を設定しています",
        message: "もう一度設定しますか？\n履歴がリセットされます",
        preferredStyle: .alert)
      
      OnepushDoneAlert.addAction(UIAlertAction(title: "キャンセル", style: .default))
      
      OnepushDoneAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
        
        UIView.animate(withDuration: 1.3) {
          self.resultmony.value = 100
          self.resultmony.progressColor = UIColor.yellow
          self.resultmony.progressStrokeColor = UIColor.yellow
          
        }
        
        var onepush = self.onepushud.integer(forKey: "onepushmony")
        self.ud3.set(self.resultmony.value, forKey: "resultmonyyy")
        
        self.TodayMony.text = self.method.CommaAdd(comma: onepush)
        
        self.ud.set(onepush, forKey: "mony")
        self.ud4.set(onepush, forKey: "mony2")
        self.TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
        self.hashBox.removeAll()
        self.hashLog.removeObject(forKey: "hash")
        
      }))
      present(OnepushDoneAlert, animated: true, completion: nil)
      
    }
    
    if JudgeOnepush.integer(forKey: "judgenum") == 0 && onepushud.integer(forKey: "onepushmony") != 0{
      
      ud3.set(resultmony.value, forKey: "resultmonyyy")
      
      TodayMony.text = method.CommaAdd(comma: onepush)
      
      ud.set(onepush, forKey: "mony")
      ud4.set(onepush, forKey: "mony2")
      TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
      UIView.animate(withDuration: 1.3) {
        self.resultmony.value = 100
        self.resultmony.progressColor = UIColor.yellow
        self.resultmony.progressStrokeColor = UIColor.yellow
        
      }
      self.ud3.set(self.resultmony.value, forKey: "resultmonyyy")
      self.ud.set(onepush, forKey: "mony")
      self.ud4.set(onepush, forKey: "mony2")
      
    }else{
      
      onePushedNotice()
     
    }
    JudgeOnepush.set(1, forKey: "judgenum")
   
  }
  
  var hashBox:[String:Int] = [:]
  
  @objc func UsedMonyButton(){
    if UsedMony.text != ""{
      
      let f = DateFormatter()
      let now = Date()
      var timeBox: [String] = []
      f.timeStyle = .medium
      f.dateStyle = .short
      f.locale = Locale(identifier: "ja_JP")
      let beDate = jpTime_to_Date(str: f.string(from: now))
      let backString = jptime_to_String(date: beDate)
      
      if var hashset = hashLog.dictionary(forKey: "hash"){
        hashset[backString] = Int(UsedMony.text!)!
        hashLog.set(hashset, forKey: "hash")
      }else{
        hashBox[backString] = Int(UsedMony.text!)!
        hashLog.set(hashBox, forKey: "hash")
        print("こっちだよ")
        print("\(hashLog.dictionary(forKey: "hash"))")
        print(hashBox)
      }
      
      let dvc = detailmonyViewController()
      
      let remain = dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney") - Int(UsedMony.text!)!
      dvc.SaveOneMonthMoneyResult.set(remain, forKey: "SaveMoney")
      
      NotificationCenter.default.removeObserver(self)
      
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
        TodayMony.text = method.CommaAdd(comma: zyunresult)

        ud.set(zyunresult, forKey: "mony")
        ud.synchronize()
        UsedMony.endEditing(true)
        
        
        if zyunresult < ud4.integer(forKey: "mony2") / 2{
          self.resultmony.progressColor = UIColor.red
          self.resultmony.progressStrokeColor = UIColor.red
        }
        
        if suzi == 1{
          UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
            self.UsedMony.center.y += 10
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
          self.UsedMony.center.y += 10
        })
        suzi = 0
      }
      NotificationCenter.default.removeObserver(self)
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
                                               message: "が今日の残額でよろしいですか?\nOKを押すと履歴がリセットされます",
                                               preferredStyle: .alert)
 
    
    EndTodaysMonyAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
      
      self.JudgeOnepush.set(0, forKey: "judgenum")

      let rvc = resultViewController()
      let dvc = detailmonyViewController()
      self.todaysOneMonethMoneyRemain = dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney") - self.TodaysTotalUsedMoney.integer(forKey: "TodaysTotalUd")
      dvc.SaveOneMonthMoneyResult.set(self.todaysOneMonethMoneyRemain, forKey: "SaveMoney")
      
      let todaysResult = UIAlertController(title: "\(self.todaysOneMonethMoneyRemain)円",
        message: "が残りの使える金額です",
        preferredStyle: .alert)
      todaysResult.addAction(UIAlertAction(title: "OK", style: .destructive))
      self.present(todaysResult, animated: true, completion: nil)
      self.TodaysTotalUsedMoney.removeObject(forKey: "TodaysTotalUd")
      
      self.todaysUsedLog.removeObject(forKey: "TodaysMoneyLog")
      self.todaysUsedTime.removeObject(forKey: "Time")
      self.hashLog.removeObject(forKey: "hash")
      self.hashBox.removeAll()
    }))
    
    
    
    EndTodaysMonyAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler :{ action in
      if self.suzi == 1{
        UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
          self.UsedMony.center.y += 10
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
  
  
  @IBOutlet weak var UpsideToolBar: UIToolbar!
  
  func ontap(){
    let onePushSetData = self.onepushud.integer(forKey: "onepushmony")
    
    TodayMony.text = method.CommaAdd(comma: ud.integer(forKey: "mony"))
    percentSet()
    
    if onePushSetData == 0{
      onePushTitle.setTitle("1psuh設定", for: .normal)
    }else{
      onePushTitle.setTitle(method.CommaAdd(comma: onePushSetData), for: .normal)
    }
  }
  
  func percentSet(){
    
    if let logs = hashLog.dictionary(forKey: "hash"){
      var valueBox: [Int] = []
      
      for key in (logs.keys){
        valueBox.append(logs[key] as! Int)
      }
      
      let logsTotal = valueBox.reduce(0){$0 + $1}
      
      let resultPercent = float_t(logsTotal) / float_t(ud4.integer(forKey: "mony2")) * 100
      ud3.set(100 - resultPercent, forKey: "resultmonyyy")
      print(resultPercent)
      resultmony.value =  CGFloat(ud3.float(forKey: "resultmonyyy"))
      if logsTotal > ud4.integer(forKey: "mony2") / 2{
        self.resultmony.progressColor = UIColor.red
        self.resultmony.progressStrokeColor = UIColor.red
        print("赤の方")
      }else{
        self.resultmony.progressColor = UIColor.yellow
        self.resultmony.progressStrokeColor = UIColor.yellow
        print("黄色の方")
      }
    }
    
  }
  
  func jpTime_to_Date(str:String) -> Date{
    
    let now = Date()
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
    dateFormater.locale = Locale(identifier: "ja_JP")
    
    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
    var tbox = dateFormater.date(from: str)
    //    tbox?.addTimeInterval(60*60 * -13*1) テスト用時間変更メソッド
    
    return tbox!
  }
  
  func beTime(str:String) -> Date{
    let now = Date()
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"
    dateFormater.locale = Locale(identifier: "ja_JP")
    
    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
    var tbox = dateFormater.date(from: str)
    
     return tbox!
  }
  
  func jptime_to_String(date:Date) -> String{
    let now = Date().toStringWithCurrentLocale()
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy/MM/dd H:mm:ss"
    dateFormater.locale = Locale(identifier: "ja_JP")
    
    return dateFormater.string(from: date)
  }

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

extension ViewController: MyTabBarDelegate{
  func didSelectTab(tabBarController: UITabBarController) {
    ontap()
  }

}

extension UITextField{
  override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
    return false
  }
}

extension Date {
  
  func toStringWithCurrentLocale() -> String {
    
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter.string(from: self)
  }
  
}
