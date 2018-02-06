//
//  ExampleTabViewController.swift
//  Example
//
//  Created by Naohiro Hamada on 2018/02/07.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit
import InAppRouter

class ExampleTabViewController: UITabBarController, RoutableViewController {
    
    static var storyboardName: String {
        return "ExampleTab"
    }
    
    static var storyboardIdentifier: String {
        return "ExampleTab"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
