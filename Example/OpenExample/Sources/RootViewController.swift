//
//  RootViewController.swift
//  OpenExample
//
//  Created by Naohiro Hamada on 2018/02/10.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onOpenTitleButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "iar-example://titles/100")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func onOpenTabButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "iar-example://tabs")!, options: [:], completionHandler: nil)
    }
}
