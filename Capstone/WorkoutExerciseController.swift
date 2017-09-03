//
//  WorkoutExerciseController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/29/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class WorkoutExerciseController {
    
    // MARK: - Class Properties
    
    static let shared = WorkoutExerciseController()
    
    // MARK: - Methods
    
    func addSetToWorkoutExercise(exerciseSet: ExerciseSet, workoutExercise: WorkoutExercise) {
        workoutExercise.sets.append(exerciseSet)
    }
    
}
