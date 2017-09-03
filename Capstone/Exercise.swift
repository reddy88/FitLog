//
//  Exercise.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/26/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class Exercise {
    
    // MARK: - Class properties
    
    private let nameKey = "name"
    private let categoryKey = "category"
    private let idKey = "id"
    
    // MARK: - Instance Properties
    
    let name: String
    let category: Int
    let id: Int
    var isSelected: Bool = false
    
    // MARK: - Initializers
    
    init(name: String, category: Int, id: Int) {
        self.name = name
        self.category = category
        self.id = id
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[nameKey] as? String,
            let category = dictionary[categoryKey] as? Int,
            let id = dictionary[idKey] as? Int else { return nil }
        
        self.name = name
        self.category = category
        self.id = id
    }
    
}

// MARK: Equatable

extension Exercise: Equatable {
    static func ==(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
}
