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
  let salaryPickerView = UIPickerView()
  let toolbar = UIToolbar()


  var buttonText = ""

  
  @IBOutlet weak var oneMonthMoneyRemain: UILabel!
  
  var SegueUsedMoney = 0
  
  @IBOutlet weak var remainMoneySetButtom: NSLayoutConstraint!
  
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    toolbar.barStyle = UIBarStyle.default
    toolbar.sizeToFit()
    
    let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
    let commitButton = UIBarButtonItem(title: "決定", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.commit))
    let cancelButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelButton))
    toolbar.items = [cancelButton,spacer, commitButton]
    
    salaryPickerView.delegate = self
    salaryPickerView.dataSource = self
    let uiScreenSize = UIScreen.main.nativeBounds.size.width
    
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
  
  
  @IBOutlet weak var buttonTitle: SimpleButton!
  
  func buttonTitleSet(title:String){
    buttonTitle.setTitle(title, for: .normal)
  }
  
  @IBOutlet weak var coverView: UIView!

  let days = ["1日", "2日", "3日", "4日", "5日", "6日", "7日", "8日", "9日", "10日", "11日", "12日", "13日", "14日", "15日", "16日", "17日", "18日", "19日", "20日", "21日", "22日", "23日", "24日", "25日", "26日", "27日", "28日", "29日", "30日", "月末"]
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return days.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return days[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    getsalaryDayText = days[row]
    getSalaryAlertTextField.text = days[row]
    print(getsalaryDayText)
  }
  
  let salaryDay = UserDefaults()
  
  var getSalaryAlert = UIAlertController()
  var getsalaryDayText = ""
  
  
  func setSalaryDay(){
    if salaryDay.integer(forKey: "salaryDay") == 0{
      salaryPickerView.selectRow(0, inComponent: 0, animated: true)
      let salaryAlert = UIAlertController(title:"給料日の設定",
                                          message:"あなたの給料日を設定してください",
                                          preferredStyle: .alert)
      getSalaryAlert = salaryAlert
      salaryAlert.addTextField(configurationHandler:{(textField: UITextField) -> Void in
        textField.delegate = self
        textField.inputView = self.salaryPickerView
        textField.inputAccessoryView = self.toolbar
        textField.text = self.days[0]
        self.getsalaryDayText = textField.text!
        self.getSalaryAlertTextField = textField
      } )
      
      self.present(salaryAlert, animated: true, completion: nil)
      
    }else{
//      let resultDate = salaryDay.integer(forKey: "salaryDay") - getDate()
//      let result = ViewController().remainResult.integer(forKey: "remain") / resultDate
//      print(resultDate)
//      print(ViewController().remainResult.integer(forKey: "remain"))
    }
  }
  
  func canUseMoneyNextSalaryDay(){
    if salaryDay.integer(forKey: "salaryDay") > nowDate(){
      
    }
  }
  
  var getSalaryAlertTextField = UITextField()
  @objc func commit(){
    getSalaryAlert.dismiss(animated: true, completion: nil)
    let result = getsalaryDayText.components(separatedBy: "日")
    salaryDay.set(Int(result[0])!, forKey: "salaryDay")
    let sucsessAlert = UIAlertController(title:"設定が完了しました",
                                         message:nil,
                                         preferredStyle: .alert)
  sucsessAlert.addAction(UIAlertAction(title: "OK", style: .default))
  self.present(sucsessAlert, animated: true, completion: nil)
  }
  
  @objc func cancelButton(){
    getSalaryAlert.dismiss(animated: true, completion: nil)
    
  }
  
//  func futureDate() -> Date{
//    let today : Date = Date()
//    let dfm = DateFormatter()
//    dfm.dateFormat = "yyyy/MM/dd"
//    dfm.locale = Locale(identifier: "ja_JP")
//
//
//    var calendar = Calendar.current
//    calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
//    calendar.locale = Locale(identifier: "ja_JP")
//    let year = calendar.component(.year, from: today)
//    let day = calendar.component(.day, from: today)
//    let month = calendar.component(.month, from: today)
//    let time = calendar.component(.hour, from: today)
//
//    let res = dfm.date(from: "\(year)/\(month)/\(day)")
//
//
//    return res!
//  }
  
  func nowDate() -> Int{
    let now = Date()
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "dd"
    dateFormater.locale = Locale(identifier: "ja_JP")
    return Int(dateFormater.string(from: now))!
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


