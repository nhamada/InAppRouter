//
//  PresentationStrategy.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/08.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit

/**
 * View controller presentation policy.
 */
public enum PresentationPolicy {
    /**
     * Present view controller as following rule:
     *
     * - If a top view controller is an instance of `UINavitationController` of a subclass of `UINavigationController`,
     *   new view controller is pushed.
     * - Otherwise, new view controller is present modally.
     *
     * This policy is used as default policy.
     */
    case pushIfPossible
    /**
     * Push view controller to the current navigation stack.
     * If there are no navigation stack, view controller is not presented.
     */
    case pushAlways
    /**
     * Present view controller modally.
     */
    case present
}

/**
 * Strategy to present view controller.
 *
 * - How to present view controller (`push`/`present`).
 * - Using `UINavigationController` or not.
 */
public final class PresentationStrategy {
    /**
     * Default stragety to present view controller
     *
     * Presentation policy is `pushIfPossible`.
     * If a top view controller is an instance of `UINavigationController`, view controller is pushed.
     * Otherwise, view controller is presented modally.
     * When view controller is presented modally, `UINavigationController` is instantiated and its root view controller is new view controller.
     */
    public static let `default`: PresentationStrategy = PresentationStrategy(policy: .pushIfPossible,
                                                                             navigationControllerClass: UINavigationController.self)
    
    /// View controller presentation policy.
    public let policy: PresentationPolicy
    /**
     * `UINavigationController` class.
     *
     * When new view controller is presented modally, this class is instantiated.
     */
    public let navigationControllerClass: UINavigationController.Type?
    
    /**
     * Initialize view controller presentation strategy.
     *
     * - parameters:
     *   - policy: View controller presentation policy.
     *   - navigationControllerClass: `UINavigationController` class which contains new view controller.
     */
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
