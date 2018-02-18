//
//  InAppRouter.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/06.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

/**
 * Key name of `Info.plist` (`IARBundleRoutingTable`).
 * Corresponding value represents a file name of a routing table for App.
 */
public let IARBundleRoutingTableKey = "IARBundleRoutingTable"

/**
 * Router which routes a URL to specific view controller or open URL in a default browser.
 */
public final class InAppRouter {
    // MARK: - Public static properties
    
    /**
     * Default router.
     *
     * If you need a specific router, instantiate other `InAppRouter` instance.
     */
    public static let `default`: InAppRouter = InAppRouter(label: "default")
    
    /**
     * Supported URL schemes in a router.
     *
     * URL schemes are defined in `Info.plist` with `CFBundleURLTypes`.
     */
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
    
    /// Router's label which is used to identify a router.
    private let label: String
    /// Routable  endpoints
    private var endpoints: [InAppEndpoint] = []
    
    // MARK: - Initializers
    
    /**
     * Initialize a router with label.
     *
     * - parameters:
     *   - label: Label to identify a router.
     */
    public init(label: String) {
        self.label = label
    }
    
    // MARK: - Public static methods
    
    /**
     * Load a routing endpoints from a resource.
     * A routing endpoints are defined in a file which are given by `Info.plist` with key `IARBundleRoutingTableKey`.
     */
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
    
    /**
     * Load a routing endpoints from a given JSON file.
     *
     * - parameters:
     *   - path: A JSON file path.
     */
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
    
    /**
     * Define an endpoint.
     *
     * - parameters:
     *   - endpoint: Endpoint string.
     *   - viewControllerClass: View controller class which is opened by router.
     *                          If router open a URL corresponding to a given endpoint,
     *                          router opens an instance of a given view controller class.
     */
    public func route(to endpoint: String, with viewControllerClass: RoutableViewController.Type) {
        let endpoint = InAppEndpoint(endpoint: endpoint, viewControllerClass: viewControllerClass)
        endpoints.append(endpoint)
    }
    
    /**
     * Remove a endpoint from a router.
     *
     * - parameters:
     *   - endpoint: Endpoint to remove from a router.
     *               If a given endpoint is not added to a router, this method does nothing.
     */
    public func remove(endpoint: String) {
        guard let index = endpoints.index(where: { $0.endpointComponents.path == endpoint }) else {
            return
        }
        endpoints.remove(at: index)
    }
    
    /**
     * Open a URL.
     *
     * - parameters:
     *   - path: A string representation of URL to open.
     *           `path` must be a valid presentation.
     *   - strategy: URL opening strategy.
     *               If `strategy` is unspecified, a router uses a default strategy.
     *               The default strategy is as followings:
     *               If the router finds a navigation controller, the router pushes a view controller.
     *               Otherwise, the router presents a view controller.
     * - returns: If a router open a view controller in the App, this method returns `true`. Otherwise, this method returns `false`.
     */
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
    
    /**
     * Open a URL.
     *
     * - parameters:
     *   - url: A URL to open.
     *   - strategy: URL opening strategy.
     *               If `strategy` is unspecified, a router uses a default strategy.
     *               The default strategy is as followings:
     *               If the router finds a navigation controller, the router pushes a view controller.
     *               Otherwise, the router presents a view controller.
     * - returns: If a router open a view controller in the App, this method returns `true`. Otherwise, this method returns `false`.
     */

    @discardableResult
    public func open(url: URL, strategy: PresentationStrategy = .default) -> Bool {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }
        guard let destination = endpoints.first(where: { urlComponents.match(to: $0) }) else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
