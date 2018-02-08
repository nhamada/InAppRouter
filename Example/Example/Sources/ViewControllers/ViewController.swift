//
//  ViewController.swift
//  Example
//
//  Created by Naohiro Hamada on 2018/02/06.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit
import InAppRouter

class ViewController: UIViewController {

    @IBOutlet weak var tabsButton: UIButton!
    @IBOutlet weak var titleId10Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onButtonTapped(_ sender: UIButton) {
        switch sender {
        case tabsButton:
            InAppRouter.default.route(to: "/tabs")
        case titleId10Button:
            InAppRouter.default.route(to: "/titles/10")
        default:
            break
        }
    }
    
}

