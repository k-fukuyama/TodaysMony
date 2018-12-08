//
//  detailmonyViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/04/06.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit
import Foundation

class detailmonyViewController: UIViewController, UITextFieldDelegate{
  
  let formatter = NumberFormatter()
  let introalertjudge = UserDefaults()
  var SendOneDayMoney = 0
  let SaveOneMonthMoneyResult = UserDefaults()

  @IBOutlet weak var numBottom: NSLayoutConstraint!
  @IBOutlet weak var salaryText: UILabel!
  
  @IBOutlet weak var eatCostText: UILabel!
  let uiScreenSize = UIScreen.main.nativeBounds.size.width
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    if uiScreenSize < 750.0{
      numBottom.constant = 40
    }else if uiScreenSize >= 828.0{
      numBottom.constant = 160
    }
      

        // Do any additional setup after loading the view.
      
      
      formatter.numberStyle = NumberFormatter.Style.decimal
      formatter.groupingSeparator = ","
      formatter.groupingSize = 3
      let methodStruct = MethodStruct()
      
      let toolbar = methodStruct.toolbarMaker()
      
      let spacer = methodStruct.spacer(className: self)
      let commitbutton = UIBarButtonItem(title: "決定", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.commit))
      let cancelButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelButton))
      toolbar.items = [cancelButton,spacer, commitbutton]
      
    let keyboards = [salary, eatCost, housemony, lifelinemony, phonemony, cardmony, transportmony, entertainmentmony, netmony, othermony]
    
    var tagAssignNum = 0
    for keyboard in keyboards{
      keyboard?.keyboardType = UIKeyboardType.numberPad
      keyboard?.inputAccessoryView = toolbar
      keyboard?.delegate = self
      tagAssignNum += 1
      keyboard?.tag = tagAssignNum
    }
    
    func beString(int: Int) -> String{
      return String(int)
    }
    
    let fixedCostSet = fixedCostUd.dictionary(forKey: "fixedCost")
   
    if let fixedCostSet = fixedCostSet{
      housemony.text = fixedCostSet["housemoney"] as! String
      transportmony.text = fixedCostSet["transportmoney"] as! String
      netmony.text = fixedCostSet["netmoney"] as! String
      salary.text = fixedCostSet["salary"] as! String
    }else{
      print("There are Optionals")
    }
    
      let notificationCenter = NotificationCenter.default
      notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)) , name: .UIKeyboardWillShow, object: nil)
      notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: .UIKeyboardWillHide, object: nil)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
      
    }
  
  
  override func viewDidAppear(_ animated: Bool) {
    if introalertjudge.integer(forKey: "introalertnum") != 1{
      let introAlert = UIAlertController(title: "1ヶ月に使える金額計算",
                                         message: "1ヶ月に使える金額を計算します費用を入力してください",
                                         preferredStyle: .alert)
      
      introAlert.addAction(UIAlertAction(title: "OK", style: .default))
      introAlert.addAction(UIAlertAction(title: "今後表示しない", style: .default, handler: { action in
        var judgenum = 1
        self.introalertjudge.set(judgenum, forKey: "introalertnum")
        self.introalertjudge.synchronize()
      }))
      
      self.present(introAlert, animated: true, completion:  nil)
    }
    
  }
  
  
  
  var num = 0
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.text = removeComa(str: removeComa(str: textField.text!))
    num = textField.tag
  }
  
  @objc func commit(){
    
    let textField = UITextField()
    textField.tag = num
    var nextTag = textField.tag + 1
    
    if let nextTextField = self.view.viewWithTag(nextTag){
      nextTextField.becomeFirstResponder()
    }
    
    if nextTag == 11{
      othermony.endEditing(true)
    }
  }
  
  @objc func cancelButton(){
    switch num {
    case 1:
      salary.endEditing(true)
    case 2:
      eatCost.endEditing(true)
    case 3:
      housemony.endEditing(true)
    case 4:
      lifelinemony.endEditing(true)
    case 5:
      phonemony.endEditing(true)
    case 6:
      cardmony.endEditing(true)
    case 7:
      transportmony.endEditing(true)
    case 8:
      entertainmentmony.endEditing(true)
    case 9:
      netmony.endEditing(true)
    case 10:
      othermony.endEditing(true)
    
    default:
      print("none")
    }
    
  }
    
  @IBOutlet weak var salary: UITextField!
  @IBOutlet weak var housemony: UITextField!
  @IBOutlet weak var lifelinemony: UITextField!
  @IBOutlet weak var phonemony: UITextField!
  @IBOutlet weak var cardmony: UITextField!
  @IBOutlet weak var transportmony: UITextField!
  @IBOutlet weak var entertainmentmony: UITextField!
  @IBOutlet weak var othermony: UITextField!
  @IBOutlet weak var netmony: UITextField!
  @IBOutlet weak var eatCost: UITextField!
  
  var salaryint = 0
  var eatInt = 0
  var houseint = 0
  var lifelineint = 0
  var phoneint = 0
  var cardint = 0
  var transportint = 0
  var entertainmantint = 0
  var otherint = 0
  
  var costarray:[String] = []
  var textarray:[String] = []
  let fixedCostUd = UserDefaults()
  
  @IBAction func total(_ sender: Any) {
    
    
    textarray = [lifelinemony.text!, phonemony.text!, cardmony.text!, entertainmentmony.text!, othermony.text!, eatCost.text!]
    
    
    if salary.text == ""{
      let emptyalert = UIAlertController(title: "手取り額を入力してください",
                                         message: "手取り額を入力しないと金額計算できません",
                                         preferredStyle: .alert)
      
      emptyalert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(emptyalert, animated: true, completion: nil)
    }else{
      let benumsarary = Int(removeComa(str: salary.text!) )
      costarray = [housemony.text!, transportmony.text!, lifelinemony.text!, phonemony.text!, cardmony.text!, entertainmentmony.text!, othermony.text!, netmony.text!, eatCost.text!]
      
      for var (index, text) in  costarray.enumerated(){
        if text == ""{
          costarray[index] = "0"
        }
      }

      
      let deletecomma = costarray.map{removeComa(str: $0)}
      var fixedCost = ["housemoney": housemony.text!, "transportmoney": transportmony.text!, "netmoney": netmony.text!,"salary": salary.text!]
      
      let removeCommaFixedCost = fixedCost.values.map{removeComa(str: $0)}
      fixedCostUd.set(fixedCost, forKey: "fixedCost")
      
      let total = deletecomma.map{Int($0)!}
      
      let cal = Calendar.current
      let date = Date()
      let thisMonthDays = cal.range(of: .day, in: .month, for: date as Date)?.count
      
      
      let result = total.reduce(0){$0 + $1}
      let OneMonthMonyResult = benumsarary! - result
      let OneDayMoneyResult = OneMonthMonyResult / thisMonthDays!
      SendOneDayMoney = OneMonthMonyResult / thisMonthDays!
     
      
      
      
      
      let OneMonthMonyAlert = UIAlertController(title: String("\(OneMonthMonyResult)円"),
        message: "が1ヶ月あたりに使用できる金額です",
        preferredStyle: .alert)
      
      
      
     
      
      let OneDayMoneyAlert = UIAlertController(title: String("\(OneDayMoneyResult)円"),
                                               message: "が1日あたりに使用できる金額です",
                                               preferredStyle: .alert)
     
      
      
      OneDayMoneyAlert.addAction(UIAlertAction(title: "OK", style: .default))
      OneDayMoneyAlert.addAction(UIAlertAction(title: "1pushに設定する", style: .default){ action in
        let SendOneDayMoneySegue = UIAlertController(title: "設定が完了しました",
                                                     message: "",
                                                     preferredStyle: .alert)
        
        let vc = ViewController()
        vc.onepushud.set(self.SendOneDayMoney, forKey: "onepushmony")
      })
      

      OneMonthMonyAlert.addAction(UIAlertAction(title: "OK", style: .default){ action in
        
        self.present(OneDayMoneyAlert, animated: true, completion: nil)
       
      })
      
      OneMonthMonyAlert.addAction(UIAlertAction(title: "残りの金額に設定する", style: .destructive){ action in
        
        self.SaveOneMonthMoneyResult.set(OneMonthMonyResult, forKey: "SaveMoney")
        self.present(OneDayMoneyAlert, animated: true, completion: nil)
        
      })
      

      present(OneMonthMonyAlert, animated: true, completion: nil)
      
      
    }
  
  }
  
 
  
  @objc func handleKeyboardWillShowNotification(_ notification: Notification){
      let userInfo = notification.userInfo
      let keyBoardSize = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
      let keyBoardY = self.view.frame.size.height - keyBoardSize.height
      let edithingTextField: CGFloat = (self.netmony.frame.origin.y)
      if edithingTextField > keyBoardY - 60 && num >= 1 && uiScreenSize < 750{
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
          self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (edithingTextField - (keyBoardY - 30)), width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        salaryText.textColor = UIColor.black
        eatCostText.textColor = UIColor.black
      }
    



  }

  @objc private func handleKeyboardWillHideNotification(_ notification: Notification) {
    UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
      self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }, completion: nil)
    salaryText.textColor = UIColor.white
    eatCostText.textColor = UIColor.white

  }

  
//
  
  @IBAction func movebefore(_ sender: Any) {
    self.performSegue(withIdentifier: "back", sender: nil)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 7
    var str = textField.text! + string
    
    if str.characters.count < maxLength{
      return true
    }
    
    return false
    
  }
  
  func addComma(str:String) -> String{
    if (str != ""){
      return formatter.string(from: Int(str) as! NSNumber)!
    }else{
      return ""
    }
  }
  
  func removeComa(str:String) -> String{
    let tmp = str.replacingOccurrences(of: ",", with: "")
    return tmp
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.text = addComma(str: textField.text!)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
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

