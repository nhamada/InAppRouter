//
//  QueryViewController.swift
//  Example
//
//  Created by Naohiro Hamada on 2018/02/08.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit
import InAppRouter

class QueryViewController: UIViewController, RoutableViewController {
    static let storyboardName: String = "Query"
    static let storyboardIdentifier: String = "Query"

    @objc var query: String = ""
    @objc var optionalQuery: String?
    @objc var optionalValue: Int = -1

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addLabel(query)
        if let option = optionalQuery {
            addLabel(option)
        }
        if optionalValue >= 0 {
            addLabel("Option: \(optionalValue)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addLabel(_ string: String) {
        let label = UILabel(frame: CGRect.zero)
        label.text = string
        label.sizeToFit()
        stackView.addSubview(label)
        stackView.addArrangedSubview(label)
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
