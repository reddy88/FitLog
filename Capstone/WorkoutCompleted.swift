//
//  WorkoutCompleted.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/3/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation
import CoreData

extension WorkoutCompleted {
    
    // MARK: - Initializers
    
    convenience init(plannedWorkout: Workout, actualWorkout: ActualWorkout, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.plannedWorkout = plannedWorkout
        self.actualWorkout = actualWorkout
        self.date = date as NSDate
        self.time = 0
    }
    
}
