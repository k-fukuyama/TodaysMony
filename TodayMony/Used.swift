//
//  Used.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/04/12.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class Used: UITextField,UITextFieldDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  
  
  override func awakeFromNib() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
  }
  
  @objc func keyboardWillShow(_ notification:NSNotification!){
    UITextField.animate(withDuration:0.10, delay:0.0, options: .curveLinear, animations:{
      self.center.y -= 20
            })
  }
  
    
  }

