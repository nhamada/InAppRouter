//
//  URLComponents+Schemes.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/10.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

extension URLComponents {
    var isHttp: Bool {
        guard let scheme = scheme else {
            return false
        }
        return scheme == "http" || scheme == "https"
    }
    
    var isInAppScheme: Bool {
        guard let scheme = scheme else {
            return true
        }
        return InAppRouter.supportedSchemes.contains(scheme)
    }
}
