//
//  WorkoutCompleted.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/3/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class WorkoutCompleted {
    
    // MARK: - Properties
    
    let plannedWorkout: Workout
    let actualWorkout: Workout
    let date: Date
    var time: TimeInterval
    
    // MARK: - Initializers
    
    init(plannedWorkout: Workout, actualWorkout: Workout, date: Date) {
        self.plannedWorkout = plannedWorkout
        self.actualWorkout = actualWorkout
        self.date = date
        self.time = 0
    }
    
}
