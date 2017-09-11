//
//  Cloneable.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/3/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

protocol Cloneable {
    
    init(instance: Self)
    
}

extension Cloneable {
    
    func copy() -> Self {
        return Self.init(instance: self)
    }
    
}

extension Array where Element: Cloneable {
    
    func copy() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
    
}
