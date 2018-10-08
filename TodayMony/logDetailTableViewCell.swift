//
//  logDetailTableViewCell.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/09/30.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class logDetailTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      logTextfield.delegate = self
      self.logTextfield.keyboardType = UIKeyboardType.numberPad
      let toolbar = UIToolbar()
      toolbar.barStyle = UIBarStyle.default
      toolbar.sizeToFit()
      
      let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
      let commitbutton = UIBarButtonItem(title: "決定", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.commit))
      toolbar.items = [spacer, commitbutton]
      logTextfield.inputAccessoryView = toolbar
      editedLog = ""
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBOutlet weak var logTextfield: UITextField!
 
  @objc func commit(){
    if logTextfield.text! != ""{
      logTextfield.endEditing(true)
      editedLog = logTextfield.text!
     
    }else{
      logTextfield.endEditing(true)
    }
    
  }
  
}
