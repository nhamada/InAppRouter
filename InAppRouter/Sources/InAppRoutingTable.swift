//
//  InAppRoutingTable.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/10.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

struct InAppRoutingEndpoint: Codable {
    let endpoint: String
    let viewControllerClassName: String
    
    enum CodingKeys: String, CodingKey {
        case endpoint
        case viewControllerClassName = "view_controller_class_name"
    }
}

struct InAppRoutingTable: Codable {
    let label: String?
    let endpoints: [InAppRoutingEndpoint]
}
