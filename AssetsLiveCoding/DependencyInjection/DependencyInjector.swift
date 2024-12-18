//
//  File.swift
//  AssetsLiveCoding
//
//  Created by Pedro Vargas on 17/12/24.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = DIContainer.resolve(T.self)
    }
}

class DIContainer {
    private static var container: [String: Any] = [:]
    
    static func register<T>(_ service: T) {
        container[String(describing: T.self)] = service
    }
    
    static func resolve<T>(_ type: T.Type) -> T {
        return container[String(describing: type)] as! T
    }
}
