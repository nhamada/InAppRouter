//
//  InAppRouter.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/06.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

public final class InAppRouter {
    // MARK: - Public static properties
    
    public static let `default`: InAppRouter = InAppRouter()
    
    // MARK: - Private properties
    
    private var endpoints: [InAppEndpoint] = []
    
    // MARK: - Initializers
    
    public init() { }
    
    // MARK: - Public methods
    
    public func register(endpoint: String, with viewControllerClass: RoutableViewController.Type) {
        let endpoint = InAppEndpoint(endpoint: endpoint, viewControllerClass: viewControllerClass)
        endpoints.append(endpoint)
    }
    
    @discardableResult
    public func route(to urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }
        return route(to: url)
    }
    
    @discardableResult
    public func route(to url: URL) -> Bool {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }
        guard let destination = endpoints.first(where: { urlComponents.match(to: $0) }) else {
            return false
        }
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }
        let viewController = destination.instantiateViewController(bundle: Bundle.main)
        // TODO: Configure view controller with `url`
        
        // TODO: Control `present` or `push`
        rootViewController.present(viewController, animated: true, completion: nil)
        
        return true
    }
    
    // MARK: - Private methods
}
