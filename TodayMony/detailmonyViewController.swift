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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      
      formatter.numberStyle = NumberFormatter.Style.decimal
      formatter.groupingSeparator = ","
      formatter.groupingSize = 3
      
      
      
      salary.delegate = self
      housemony.delegate = self
      lifelinemony.delegate = self
      phonemony.delegate = self
      cardmony.delegate = self
      transportmony.delegate = self
      entertainmentmony.delegate = self
      othermony.delegate = self
      netmony.delegate = self
      
      let toolbar = UIToolbar()
      toolbar.barStyle = UIBarStyle.default
      toolbar.sizeToFit()
      
      let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
      let commitbutton = UIBarButtonItem(title: "決定", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.commit))
      toolbar.items = [spacer, commitbutton]
      
      salary.inputAccessoryView = toolbar
      housemony.inputAccessoryView = toolbar
      lifelinemony.inputAccessoryView = toolbar
      phonemony.inputAccessoryView = toolbar
      cardmony.inputAccessoryView = toolbar
      transportmony.inputAccessoryView = toolbar
      entertainmentmony.inputAccessoryView = toolbar
      othermony.inputAccessoryView = toolbar
      netmony.inputAccessoryView = toolbar
      
      self.salary.keyboardType = UIKeyboardType.numberPad
      self.housemony.keyboardType = UIKeyboardType.numberPad
      self.lifelinemony.keyboardType = UIKeyboardType.numberPad
      self.phonemony.keyboardType = UIKeyboardType.numberPad
      self.cardmony.keyboardType = UIKeyboardType.numberPad
      self.transportmony.keyboardType = UIKeyboardType.numberPad
      self.entertainmentmony.keyboardType = UIKeyboardType.numberPad
      self.othermony.keyboardType = UIKeyboardType.numberPad
      netmony.keyboardType = UIKeyboardType.numberPad
      
      salary.text = ""
      housemony.text = ""
      lifelinemony.text = ""
      phonemony.text = ""
      cardmony.text = ""
      transportmony.text = ""
      entertainmentmony.text = ""
      othermony.text = ""
      netmony.text = ""
      
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
  
  @objc func commit(){
    salary.endEditing(true)
    housemony.endEditing(true)
    lifelinemony.endEditing(true)
    phonemony.endEditing(true)
    cardmony.endEditing(true)
    transportmony.endEditing(true)
    entertainmentmony.endEditing(true)
    othermony.endEditing(true)
    netmony.endEditing(true)
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
  
  var salaryint = 0
  var houseint = 0
  var lifelineint = 0
  var phoneint = 0
  var cardint = 0
  var transportint = 0
  var entertainmantint = 0
  var otherint = 0
  
  var costarray:[String] = []
  var textarray:[String] = []
  
  @IBAction func total(_ sender: Any) {
    
    
    textarray = [housemony.text!, lifelinemony.text!, phonemony.text!, cardmony.text!, transportmony.text!, entertainmentmony.text!, othermony.text!]
    
    
    if salary.text == ""{
      let emptyalert = UIAlertController(title: "手取り額を入力してください",
                                         message: "手取り額を入力しないと金額計算できません",
                                         preferredStyle: .alert)
      
      emptyalert.addAction(UIAlertAction(title: "OK", style: .default))
    }else{
      let benumsarary = Int(removeComa(str: salary.text!) )
      costarray = [housemony.text!, lifelinemony.text!, phonemony.text!, cardmony.text!, transportmony.text!, entertainmentmony.text!, othermony.text!, netmony.text!]
      
      for var (index, text) in  costarray.enumerated(){
        if text == ""{
          costarray[index] = "0"
          print("AAA\(costarray[index])")
        }
        }
      
      let deletecomma = costarray.map{removeComa(str: $0)}
      
      let total = deletecomma.map{Int($0)!}
      
      
      let result = total.reduce(0){$0 + $1}
      let result2 = benumsarary! - result
      print(result2)
      
      let OneMonthMony = UIAlertController(title: "\(result2)",
        message: "あなたが1ヶ月に使える自由な金額の総合です",
        preferredStyle: .alert)
      
      OneMonthMony.addAction(UIAlertAction(title: "OK", style: .default))
      
      present(OneMonthMony, animated: true, completion: nil)
      
      print("\(total)")
    }
  }
  
  
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
//      formatter.string(from: Int(MonyField.text!) as! NSNumber)!
    }else{
      return ""
    }
  }
  
  func removeComa(str:String) -> String{
    let tmp = str.replacingOccurrences(of: ",", with: "")
    return tmp
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.text = addComma(str: removeComa(str: textField.text!))
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

