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
    @IBOutlet weak var queryWithoutOptionButton: UIButton!
    @IBOutlet weak var queryWithOptionButton: UIButton!
    @IBOutlet weak var openGoogleButton: UIButton!
    @IBOutlet weak var openYahooButton: UIButton!
    
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
            InAppRouter.default.open(path: "/tabs")
        case titleId10Button:
            InAppRouter.default.open(path: "/titles/10")
        case queryWithoutOptionButton:
            InAppRouter.default.open(path: "/query/NoOption")
        case queryWithOptionButton:
            InAppRouter.default.open(path: "/query/option?optionalQuery=\"Test data\"&optionalValue=42")
        case openGoogleButton:
            InAppRouter.default.open(path: "https://www.google.com/")
        case openYahooButton:
            InAppRouter.default.open(path: "http://www.yahoo.co.jp/")
        default:
            break
        }
    }
    
}

