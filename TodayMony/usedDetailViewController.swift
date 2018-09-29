//
//  usedDetailViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/09/29.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class usedDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction func backButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}
