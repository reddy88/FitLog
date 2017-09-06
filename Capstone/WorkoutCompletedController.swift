//
//  WorkoutCompletedController.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/3/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class WorkoutCompletedController {
    
    // MARK: - Class Properties
    
    static let shared = WorkoutCompletedController()
    
    // MARK: - Instance Properties
    
    var workoutsCompleted: [WorkoutCompleted] = []
    var pendingWorkoutCompleted: WorkoutCompleted?
    
    // MARK: - Methods
    
    func createPendingWorkoutCompleted(plannedWorkout: Workout, actualWorkout: Workout, date: Date = Date()) {
        let pendingWorkoutCompleted = WorkoutCompleted(plannedWorkout: plannedWorkout, actualWorkout: actualWorkout, date: date)
        self.pendingWorkoutCompleted = pendingWorkoutCompleted
    }
    
}
