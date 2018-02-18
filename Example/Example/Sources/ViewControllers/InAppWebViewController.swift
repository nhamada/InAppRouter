//
//  InAppWebViewController.swift
//  Example
//
//  Created by Naohiro Hamada on 2018/02/18.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit
import WebKit
import InAppRouter

class InAppWebViewController: UIViewController, WebRoutableViewController {
    public static let storyboardName: String = "InAppWeb"
    public static let storyboardIdentifier: String = "InAppWeb"
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let url = url else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
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
