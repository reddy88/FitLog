//
//  ActualWorkout.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/13/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation
import CoreData

extension ActualWorkout {
    
    // MARK: - Initializers
    
    convenience init(name: String?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.name = name
    }
    
}
