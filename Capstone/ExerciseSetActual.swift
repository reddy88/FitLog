//
//  ExerciseSetActual.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/16/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation
import CoreData

extension ExerciseSetActual {
    
    // MARK: - Initializers
    
    convenience init(reps: Int? , weight: Int? , context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        guard let reps = reps, let weight = weight else { return }
        self.reps = Int16(reps)
        self.weight = Int16(weight)
    }
    
}
