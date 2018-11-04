//
//  struct.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/10/27.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import Foundation

struct MethodStruct {
  
  func CommaAdd(comma:Int) -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.groupingSeparator = ","
    formatter.groupingSize = 3
    
    let becomma = "¥\(formatter.string(from: Int(comma) as! NSNumber)!)"
    
    return becomma
  }
  
  func removeComa(str:String) -> String{
    let tmp = str.replacingOccurrences(of: ",", with: "")
    return tmp
  }
}
