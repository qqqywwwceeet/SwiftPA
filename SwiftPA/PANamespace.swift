//
//  PAScrollView.swift
//  SwiftPA
//
//  Created by 云天明 on 2021/12/14.
//

import UIKit

public struct PAExtensionNamespace<T> {
    
    let base: T
    public init(_ base: T) {
        self.base = base
    }
    
}

public protocol PAExtensionWrappable {
    
    associatedtype T
    var pa: T { get }
    static var pa: T.Type { get }
    
}

public extension PAExtensionWrappable {
    
    var pa: PAExtensionNamespace<Self> { PAExtensionNamespace(self) }
    static var pa: PAExtensionNamespace<Self>.Type {
        PAExtensionNamespace<Self>.self
    }
    
}
