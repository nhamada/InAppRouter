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
    
    func match(to endpoint: InAppEndpoint) -> Bool {
        // TODO: Extend to match variable in path
        return routablePath == endpoint.endpoint
    }
}
