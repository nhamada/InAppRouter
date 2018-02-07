//
//  EndpointComponents.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/07.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

enum Component {
    case label(name: String)
    case parameter(name: String, typeName: String)
    
    init(from string: Substring) {
        if string.hasPrefix("{") && string.hasSuffix("}") && string.contains(":") {
            let unwrapped = string.dropFirst().dropLast().split(separator: ":")
            guard unwrapped.count == 2 else {
                fatalError("")
            }
            self = .parameter(name: String(unwrapped[0]), typeName: String(unwrapped[1]))
        } else {
            self = .label(name: String(string))
        }
    }
}

struct EndpointComponents {
    let components: [Component]
    
    init(_ string: String) {
        if !string.hasPrefix("/") {
            components = []
            return
        }
        let substrings = string.dropFirst().split(separator: "/")
        components = substrings.map { Component(from: $0) }
    }
}

