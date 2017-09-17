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
    
    func createPendingWorkoutCompleted(actualWorkout: ActualWorkout, date: Date = Date()) {
        let pendingWorkoutCompleted = WorkoutCompleted(actualWorkout: actualWorkout, date: date)
        self.pendingWorkoutCompleted = pendingWorkoutCompleted
    }
    
    func addWorkoutCompleted(_ pendingWorkoutCompleted: WorkoutCompleted) {
        workoutsCompleted.append(pendingWorkoutCompleted)
    }
    
    func deleteWorkoutCompleted(_ workoutCompleted: WorkoutCompleted) {
        workoutCompleted.managedObjectContext?.delete(workoutCompleted)
        FetchedResultsController.shared.save()
    }
    
    func isValidWorkoutCompleted(_ workoutCompleted: WorkoutCompleted) -> Bool {
        if workoutCompleted.time == 0 {
            return false
        }
        
        return true
    }
    
}
