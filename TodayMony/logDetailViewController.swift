//
//  logDetailViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/09/29.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class logDetailViewController: UIViewController, UITextFieldDelegate{
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      print(keyBox)
      print(valueBox)
      editTextField.text! = String(valueBox[0])
      
      let toolbar = UIToolbar()
      toolbar.barStyle = UIBarStyle.default
      toolbar.sizeToFit()
      let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
      let commitbutton = UIBarButtonItem(title: "決定", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.commit))
      toolbar.items = [spacer, commitbutton]
      editTextField.inputAccessoryView = toolbar
      editTextField.keyboardType = UIKeyboardType.numberPad
      editTextField.delegate = self
    }
  
  var valueBox: [Int] = []
  var keyBox: [String] = []
  var vc = ViewController()
  
  @IBOutlet weak var editTextField: UITextField!
  
  var saveString = ""
  
    
  @IBOutlet weak var logTable: UITableView!
  
  @IBAction func backButton(_ sender: Any) {
    
    self.dismiss(animated: true, completion: {
      usedMoneyLogController().valueBox.removeAll()
      usedMoneyLogController().update()
    })
  }

  func editedAlert(){
    let editedDoneAlert = UIAlertController(title: nil,
                                            message: "編集が完了しました",
                                            preferredStyle: .alert)
    
    editedDoneAlert.addAction(UIAlertAction(title: "OK", style: .default){ action in
      self.dismiss(animated: true, completion: {
        usedMoneyLogController().valueBox.removeAll()
        usedMoneyLogController().update()
      })
    })
    
    self.present(editedDoneAlert, animated: true, completion: nil)
    
  }
  
  func emptyAlert(){
    let emptyAlert = UIAlertController(title: nil,
                                            message: "金額を入力、変更してください",
                                            preferredStyle: .alert)
    
    emptyAlert.addAction(UIAlertAction(title: "OK", style: .default))
    
    self.present(emptyAlert, animated: true, completion: nil)
    
  }
  
  func zeroAlert(){
    let zeroAlert = UIAlertController(title: nil,
                                       message: "0円は入力できません",
                                       preferredStyle: .alert)
    
    zeroAlert.addAction(UIAlertAction(title: "OK", style: .default))
    
    self.present(zeroAlert, animated: true, completion: nil)
  }
  
  
  
  @IBOutlet weak var save: UIBarButtonItem!
  
  @IBAction func saveButton(_ sender: Any) {
    
    let text = editTextField.text!
    
    if text != "" && text != "0"{
      print(editedLog)
        
        var result = 0
        let dvc = detailmonyViewController()
        var dvcSetNum = 0
        var todayRemainTextNum = 0
        
        var vcHash = vc.hashLog.dictionary(forKey: "hash")
        vcHash![keyBox[0]] = Int(text)!
        vc.hashLog.set(vcHash, forKey: "hash")
        
      if Int(text)! > valueBox[0]{
          result = Int(editTextField.text!)! - valueBox[0]
          dvcSetNum = dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney") - result
          dvc.SaveOneMonthMoneyResult.set(dvcSetNum, forKey: "SaveMoney")
          
          todayRemainTextNum = vc.ud.integer(forKey: "mony") - result
          vc.ud.set(todayRemainTextNum, forKey: "mony")
          
          editedAlert()
          
        }else{
          result = valueBox[0] - Int(text)!
          dvcSetNum = dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney") + result
          dvc.SaveOneMonthMoneyResult.set(dvcSetNum, forKey: "SaveMoney")
          
          todayRemainTextNum = vc.ud.integer(forKey: "mony") + result
          vc.ud.set(todayRemainTextNum, forKey: "mony")
          
          editedAlert()
        
        }
      
    }else if text == "0" {
      zeroAlert()
    }else{
      emptyAlert()
    }

    
 
  }
  
  func adjustment(num: Int, editedValu: Int){
    print(vc.ud.integer(forKey: "mony"))
    let beforeNum = vc.ud.integer(forKey: "mony") + num
    print("これがbefore\(beforeNum)")
    let trueNum = float_t(editedValu) / float_t(beforeNum) * 100
    
    vc.todaysMoneyRemainPercent.set(CGFloat(trueNum), forKey: "resultmonyyy")
  }
  
  @objc func commit(){
    editTextField.endEditing(true)
    
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 7
    var str = textField.text! + string
    
    if str.characters.count < maxLength{
      return true
    }
    
    return false
    
  }
  
  
  
 
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
