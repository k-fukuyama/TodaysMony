//
//  CustomTextField.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/04/19.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

    return false
  }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
