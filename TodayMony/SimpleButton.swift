//
//  SimpleButton.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/04/11.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class SimpleButton: UIButton {
  
  var selectview: UIView! = nil
  
  required init?(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)
    
    mylint()
  }
  
  override init(frame: CGRect){
    super.init(frame:frame)
    
    mylint()
  }
  
  func mylint(){
    selectview = UIView(frame: self.bounds)
    selectview.backgroundColor = UIColor.black
    selectview.alpha = 0.0
    self.addSubview(selectview)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    selectview.frame = self.bounds
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with:event)
    
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
      
      self.selectview.alpha = 0.5
      
    },completion:{(finished: Bool) -> Void in
    })
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with:event)
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
      
      self.selectview.alpha = 0.0
      
    },completion:{(finished:Bool) -> Void in
      
    })
  }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
