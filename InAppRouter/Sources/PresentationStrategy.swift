//
//  PresentationStrategy.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/08.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit

public enum PresentationPolicy {
    case pushIfPossible
    case pushAlways
    case present
}

public final class PresentationStrategy {
    public static let `default`: PresentationStrategy = PresentationStrategy(policy: .pushIfPossible,
                                                                             navigationControllerClass: UINavigationController.self)
    
    public let policy: PresentationPolicy
    public let navigationControllerClass: UINavigationController.Type?
    
    public init(policy: PresentationPolicy, navigationControllerClass: UINavigationController.Type? = nil) {
        self.policy = policy
        self.navigationControllerClass = navigationControllerClass
    }
    
    @discardableResult
    func process(viewController: UIViewController) -> Bool {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }
        return rootViewController.present(viewController: viewController, strategy: self)
    }
}
