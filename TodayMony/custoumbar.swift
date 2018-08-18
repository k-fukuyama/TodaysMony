//
//  custoumbar.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/08/14.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class custoumbar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
      
     

        // Do any additional setup after loading the view.
      self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    if viewController is MyTabBarDelegate{
      let vc = viewController as! MyTabBarDelegate
      vc.didSelectTab(tabBarController: self)
    }
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
