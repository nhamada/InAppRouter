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
    public func route(to urlString: String, strategy: PresentationStrategy = .default) -> Bool {
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return false
        }
        guard let url = URL(string: encodedUrlString) else {
            return false
        }
        return route(to: url)
    }
    
    @discardableResult
    public func route(to url: URL, strategy: PresentationStrategy = .default) -> Bool {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }
        guard let destination = endpoints.first(where: { urlComponents.match(to: $0) }) else {
            return false
        }
        let viewController = destination.instantiateViewController(bundle: Bundle.main)
        let parameters = urlComponents.retrieveParameters(for: destination.endpointComponents)
        viewController.setValuesForKeys(parameters)
        return strategy.process(viewController: viewController)
    }
    
    // MARK: - Private methods
}
