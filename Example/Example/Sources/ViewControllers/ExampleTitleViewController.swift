//
//  ExampleTitleViewController.swift
//  Example
//
//  Created by Naohiro Hamada on 2018/02/08.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit
import InAppRouter

class ExampleTitleViewController: UIViewController, RoutableViewController {
    static let storyboardName: String = "ExampleTitle"
    
    static let storyboardIdentifier: String = "ExampleTitle"
    
    @IBOutlet weak var titleIdLabel: UILabel!
    
    @objc var titleId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleIdLabel.text = String(titleId)
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
