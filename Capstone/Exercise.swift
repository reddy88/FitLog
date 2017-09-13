//
//  Exercise.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/26/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation
import CoreData

extension Exercise {
    
    // MARK: - Initializers
    
    convenience init(name: String, category: Int, id: Int, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.name = name
        self.category = Int16(category)
        self.id = Int16(id)
    }
    
    convenience init?(dictionary: [String: Any], context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        guard let name = dictionary["name"] as? String,
            let category = dictionary["category"] as? Int,
            let id = dictionary["id"] as? Int else { return nil }
        
        self.name = name
        self.category = Int16(category)
        self.id = Int16(id)
    }
    
}
