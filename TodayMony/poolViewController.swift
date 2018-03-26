//
//  poolViewController.swift
//  TodayMony
//
//  Created by Keita Fukuyama on 2018/03/16.
//  Copyright © 2018年 Keita Fukuyama. All rights reserved.
//

import UIKit

class poolViewController: UIViewController {

  @IBOutlet weak var nowpoolmony: UILabel!
  
  var poolmony = 0
  var ud = UserDefaults.standard
  
  override func viewDidLoad() {
        super.viewDidLoad()
    ud.set(poolmony, forKey: "truepoolmony")
    ud.synchronize()
    nowpoolmony.text = String("\(ud.integer(forKey: "truepoolmony"))円")
    
    print(ud.integer(forKey: "truepoolmony"))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func back(_ sender: Any) {
    performSegue(withIdentifier: "back", sender: nil)
  }
  
  override func prepare(for segue:UIStoryboardSegue, sender:Any?){
    if (segue.identifier == "back"){
      let viewcontroller:ViewController = segue.destination as! ViewController
      viewcontroller.poolmonytwo = ud.integer(forKey: "truepoolmony")
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
