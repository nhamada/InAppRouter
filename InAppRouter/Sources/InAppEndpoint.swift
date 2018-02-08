//
//  InAppEndpoint.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/06.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import UIKit

/**
 * In App routing endpoint definition.
 */
final class InAppEndpoint {
    /// Endpoint definition
    internal let endpointComponents: EndpointComponents
    /// Corresponding view controller class
    private let viewControllerClass: RoutableViewController.Type
    
    init(endpoint: String, viewControllerClass: RoutableViewController.Type) {
        self.endpointComponents = EndpointComponents(endpoint)
        print(endpointComponents)
        self.viewControllerClass = viewControllerClass
    }
    
    /**
     * Instantiate view controller from a given `Bundle`.
     *
     * - parameters:
     *   - bundle: A bundle which contains a storyboard which has a view controller
     * - returns: An instance of a view controller
     */
    func instantiateViewController(bundle: Bundle = Bundle.main) -> UIViewController {
        let storyboard = UIStoryboard.init(name: viewControllerClass.storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: viewControllerClass.storyboardIdentifier)
    }
}
