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
    
    var name: String {
        switch self {
        case .integer:
            return "Int"
        case .double:
            return "Double"
        case .string:
            return "String"
        }
    }
    
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
    
    func instantiate(_ string: String) -> Any {
        switch self {
        case .integer:
            guard let value = Int(string) else {
                fatalError()
            }
            return value
        case .double:
            guard let value = Double(string) else {
                fatalError()
            }
            return value
        case .string:
            return string
        }
    }
}

enum Component {
    case label(name: String)
    case parameter(name: String, type: ParameterType)
    
    var path: String {
        switch self {
        case .label(let name):
            return name
        case .parameter(let name, let type):
            return "{\(name):\(type.name)}"
        }
    }
    
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
    static let separator: Character = "/"
    static let separatorString = String(EndpointComponents.separator)
    
    let components: [Component]
    
    var path: String {
        return EndpointComponents.separatorString + components.map( { $0.path } ).joined(separator: EndpointComponents.separatorString)
    }
    
    init(_ string: String) {
        if !string.hasPrefix(EndpointComponents.separatorString) {
            components = []
            return
        }
        let substrings = string.dropFirst().split(separator: EndpointComponents.separator)
        components = substrings.map { Component(from: $0) }
    }
}

