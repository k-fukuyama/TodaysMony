//
//  resultViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/03/12.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class resultViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
  
  
  let ud = UserDefaults.standard
  let method = MethodStruct()
  let dvc = detailmonyViewController()
  let vi = UIView()
  var buttonText = ""

  
  @IBOutlet weak var oneMonthMoneyRemain: UILabel!
  
  var SegueUsedMoney = 0
  
  @IBOutlet weak var remainMoneySetButtom: NSLayoutConstraint!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    
    nextSalaryPicker.delegate = self
    nextSalaryPicker.dataSource = self
    
    vi.isHidden = true
    vi.center.y = 0
    
    let uiScreenSize = UIScreen.main.nativeBounds.size.width
//    vi.frame = nextSalaryPicker.bounds
     nextSalaryPicker.frame = CGRect(x:0, y:UIScreen.main.nativeBounds.size.height / 2, width: view.frame.size.width, height: nextSalaryPicker.bounds.size.height)
    
//    vi.addSubview(nextSalaryPicker)
//
//    view.addSubview(vi)
//    self.vi.bringSubview(toFront: vi)
//    self.vi.frame.origin.y += UIScreen.main.nativeBounds.size.height / 2
//
    
    coverView.isHidden = true
    
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
  
  let salaryDay = UserDefaults()
  
  func setSalaryDay(){
    if salaryDay.integer(forKey: "salaryDay") == 0{
      let alert = UIAlertController(title:"給料日の設定",
                                    message:"次の給料日まで1日あたりに使える金額を設定します",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title:"OK", style: .cancel))
      self.present(alert, animated: true, completion: nil)
      
      coverView.isHidden = false
      vi.isHidden = false
      
      UIPickerView.animate(withDuration: 0.3){
        self.nextSalaryPicker.frame.origin.y -= UIScreen.main.nativeBounds.size.height / 6
      }
      
      
    }
  }
  
  
  @IBAction func reset(_ sender: Any) {
    
    if self.segnum == 0{
      setSalaryDay()
    }else{
      var alert = UIAlertController(title:"残りの金額をリセット",
                                    message:"残りの金額をリセットします",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title:"リセットする", style:.destructive, handler:{ action in
        self.vc.remainResult.removeObject(forKey: "remain")
        self.vc.firstEnd.removeObject(forKey: "endCount")
        self.oneMonthMoneyRemain.text! = self.method.CommaAdd(comma: self.vc.remainResult.integer(forKey: "remain"))
        
      }))
      alert.addAction(UIAlertAction(title:"リセットしない", style: .cancel))
      
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
  
  func ontap(){
    if segnum == 0{
      buttonTitleSet(title: "次の給料日まで")
      oneMonthMoneyRemain.text! = method.CommaAdd(comma: dvc.SaveOneMonthMoneyResult.integer(forKey: "SaveMoney"))
    }else{
      buttonText = "リセット"
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
    let remainSetTitle = "残りの金額を設定します"
    let poolMoneySetTitle = "貯められた金額を修正します"
    var title = ""
    
    if segnum == 0{
      title = remainSetTitle
    }else{
      title = poolMoneySetTitle
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
    buttonTitleSet(title: "次の給料日まで")
    segnum = 0
  }
  
  func poolMoneyViewSet(){
    itemTitle.text! = "貯められた金額"
    oneMonthMoneyRemain.text! = method.CommaAdd(comma: ViewController().remainResult.integer(forKey: "remain"))
    setButtonTitle.setTitle("貯められた金額を設定", for: .normal)
    buttonTitleSet(title: "リセット")
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
  
  @IBOutlet weak var nextSalaryPicker: UIPickerView!
  
  @IBOutlet weak var buttonTitle: SimpleButton!
  
  func buttonTitleSet(title:String){
    buttonTitle.setTitle(title, for: .normal)
  }
  
  @IBOutlet weak var coverView: UIView!

  let days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return days.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(days[row])
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    print(days[row])
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


