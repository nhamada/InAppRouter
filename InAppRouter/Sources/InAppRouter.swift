//
//  InAppRouter.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/06.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

public let IARBundleRoutingTableKey = "IARBundleRoutingTable"

public final class InAppRouter {
    // MARK: - Public static properties
    
    public static let `default`: InAppRouter = InAppRouter(label: "default")
    
    public static var supportedSchemes: [String] {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String:Any]] else {
            return []
        }
        var schemes: [String] = []
        urlTypes.forEach { urlType in
            guard let urlSchemes = urlType["CFBundleURLSchemes"] as? [String] else {
                return
            }
            schemes.append(contentsOf: urlSchemes)
        }
        return schemes
    }
    
    // MARK: - Private properties
    
    private let label: String
    private var endpoints: [InAppEndpoint] = []
    
    // MARK: - Initializers
    
    public init(label: String) {
        self.label = label
    }
    
    // MARK: - Public static methods
    
    public static func load() -> InAppRouter {
        guard let bundleUrl = Bundle.main.resourceURL else {
            fatalError()
        }
        guard let routingTableJsonFile = Bundle.main.infoDictionary?[IARBundleRoutingTableKey] as? String else {
            fatalError()
        }
        let routingTableJsonUrl = bundleUrl.appendingPathComponent(routingTableJsonFile)
        return load(from: routingTableJsonUrl.path)
    }
    
    public static func load(from path: String) -> InAppRouter {
        let url = URL(fileURLWithPath: path)
        guard let jsonData = try? Data(contentsOf: url) else {
            fatalError()
        }
        let jsonDecoder = JSONDecoder()
        guard let routingTable = try? jsonDecoder.decode(InAppRoutingTable.self, from: jsonData) else {
            fatalError()
        }
        let router = routingTable.instantiateRouter()
        routingTable.endpoints.forEach {
            router.route(to: $0.endpoint, with: $0.viewControllerClassName)
        }
        return router
    }
    
    // MARK: - Public methods
    
    public func route(to endpoint: String, with viewControllerClass: RoutableViewController.Type) {
        let endpoint = InAppEndpoint(endpoint: endpoint, viewControllerClass: viewControllerClass)
        endpoints.append(endpoint)
    }
    
    public func remove(endpoint: String) {
        guard let index = endpoints.index(where: { $0.endpointComponents.path == endpoint }) else {
            return
        }
        endpoints.remove(at: index)
    }
    
    @discardableResult
    public func open(path: String, strategy: PresentationStrategy = .default) -> Bool {
        guard let encodedUrlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return false
        }
        guard let url = URL(string: encodedUrlString) else {
            return false
        }
        return open(url: url)
    }
    
    @discardableResult
    public func open(url: URL, strategy: PresentationStrategy = .default) -> Bool {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }
        if urlComponents.isHyperText {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return false
        }
        if !urlComponents.isInAppScheme {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
    
    // MARK: - Internal methods
    
    @discardableResult
    internal func route(to endpoint: String, with viewControllerClassName: String) -> Bool {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return false
        }
        guard let viewControllerClass = Bundle.main.classNamed("\(namespace).\(viewControllerClassName)") else {
            return false
        }
        guard let routableClass = viewControllerClass as? RoutableViewController.Type else {
            return false
        }
        route(to: endpoint, with: routableClass)
        return true
    }
    
    // MARK: - Private methods
}

fileprivate extension InAppRoutingTable {
    func instantiateRouter() -> InAppRouter {
        guard let label = label else {
            return InAppRouter.default
        }
        if label == "default" {
            return InAppRouter.default
        }
        return InAppRouter(label: label)
    }
}
