//
//  EndpointComponents.swift
//  InAppRouter
//
//  Created by Naohiro Hamada on 2018/02/07.
//  Copyright © 2018年 Naohiro Hamada. All rights reserved.
//

import Foundation

enum ParameterType {
    case integer
    case double
    case string
    
    init(_ string: String) {
        switch string {
        case "Int":
            self = .integer
        case "Double":
            self = .double
        case "String":
            self = .string
        default:
            fatalError()
        }
    }
    
    func match(to string: String) -> Bool {
        switch self {
        case .integer:
            guard let _ = Int(string) else {
                return false
            }
            return true
        case .double:
            guard let _ = Double(string) else {
                return false
            }
            return true
        case .string:
            return true
        }
    }
}

enum Component {
    case label(name: String)
    case parameter(name: String, type: ParameterType)
    
    init(from string: Substring) {
        if string.hasPrefix("{") && string.hasSuffix("}") && string.contains(":") {
            let unwrapped = string.dropFirst().dropLast().split(separator: ":")
            guard unwrapped.count == 2 else {
                fatalError("")
            }
            self = .parameter(name: String(unwrapped[0]), type: ParameterType(String(unwrapped[1])))
        } else {
            self = .label(name: String(string))
        }
    }
    
    func match(to string: String) -> Bool {
        switch self {
        case .label(let name):
            return name == string
        case .parameter(_, let type):
            return type.match(to: string)
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

