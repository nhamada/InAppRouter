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
            return "\(host)/\(path)"
        } else {
            return path
        }
    }
    
    private var routablePathComponents: [String] {
        return routablePath.split(separator: "/").map( { String($0) } )
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
}
