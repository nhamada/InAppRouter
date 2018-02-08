//
//  URLComponents+Endpoint.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/06.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

extension URLComponents {
    private var routablePath: String {
        if let host = host {
            return "\(host)\(EndpointComponents.separator)\(path)"
        } else {
            return path
        }
    }
    
    private var routablePathComponents: [String] {
        return routablePath.split(separator: EndpointComponents.separator).map( { String($0) } )
    }
    
    func match(to endpoint: InAppEndpoint) -> Bool {
        guard routablePathComponents.count == endpoint.endpointComponents.components.count else {
            return false
        }
        return zip(routablePathComponents, endpoint.endpointComponents.components).reduce(true) {
            guard $0 else {
                return false
            }
            return $1.1.match(to: $1.0)
        }
    }
    
    func retrieveParameters(for endpoint: EndpointComponents) -> [String:Any] {
        var result: [String:Any] = [:]
        zip(routablePathComponents, endpoint.components).forEach {
            switch $1 {
            case .label:
                break
            case .parameter(let name, let type):
                result[name] = type.instantiate($0)
            }
        }
        queryItems?.forEach {
            guard let value = $0.value else {
                return
            }
            result[$0.name] = value.asQueryValue
        }
        return result
    }
}

fileprivate extension String {
    var asQueryValue: Any {
        if let value = Int(self) {
            return value
        }
        if let value = Double(self) {
            return value
        }
        return self
    }
}
