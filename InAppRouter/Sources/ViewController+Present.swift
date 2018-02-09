//
//  ViewController+Present.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/09.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

extension UIViewController {
    fileprivate var _topmostViewController: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController._topViewController
        }
        
        if let presentedViewController = presentedViewController {
            return presentedViewController._topmostViewController
        }
        return self
    }
    
    func present(viewController: UIViewController, strategy: PresentationStrategy) -> Bool {
        let topmostViewController = self._topmostViewController
        switch strategy.policy {
        case .pushIfPossible:
            if let navigationController = topmostViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            } else {
                if let navigationController = topmostViewController.navigationController {
                    navigationController.pushViewController(viewController, animated: true)
                } else {
                    if let navigationControllerClass = strategy.navigationControllerClass {
                        let navigationController = navigationControllerClass.init(rootViewController: viewController)
                        topmostViewController.present(navigationController, animated: true, completion: nil)
                    } else {
                        topmostViewController.present(viewController, animated: true, completion: nil)
                    }
                }
            }
        case .pushAlways:
            if let navigationController = topmostViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            } else if let navigationController = topmostViewController.navigationController {
                navigationController.pushViewController(viewController, animated: true)
            } else {
                return false
            }
        case .present:
            if let navigationControllerClass = strategy.navigationControllerClass {
                let navigationController = navigationControllerClass.init(rootViewController: viewController)
                topmostViewController.present(navigationController, animated: true, completion: nil)
            } else {
                topmostViewController.present(viewController, animated: true, completion: nil)
            }
        }
        return true
    }
}

extension UINavigationController {
    fileprivate var _topViewController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController._topmostViewController
        }
        if let topViewController = topViewController {
            return topViewController._topmostViewController
        }
        return self
    }
}
