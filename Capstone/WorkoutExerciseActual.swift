//
//  WorkoutExerciseActual.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/16/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation
import CoreData

extension WorkoutExerciseActual {
    
    // MARK: - Initializers
    
    convenience init(exercise: Exercise, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.sets = []
        self.restTime = 0
        self.name = exercise.name
        self.category = exercise.category
        self.id = exercise.id
    }
    
}
