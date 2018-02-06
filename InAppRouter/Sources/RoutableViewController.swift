//
//  RoutableViewController.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/06.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit

/**
 * View controller protocol to route with `InAppRouter`
 */
public protocol RoutableViewController: class where Self: UIViewController {
    /// Storyboard file name witout extension (`*.storyboard`)
    static var storyboardName: String { get }
    /// Storyboard ID
    static var storyboardIdentifier: String { get }
}
