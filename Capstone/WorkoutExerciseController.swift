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
        if var sets = workoutExercise.sets?.array as? [ExerciseSet] {
            sets.append(exerciseSet)
            workoutExercise.sets = NSOrderedSet(array: sets)
        }
    }
    
    func removeWorkoutExercise(_ workoutExercise: WorkoutExercise) {
        workoutExercise.managedObjectContext?.delete(workoutExercise)
        //FetchedResultsController.shared.save()
    }
    
    func copyWorkoutExercise(_ workoutExercise: WorkoutExercise) -> WorkoutExerciseActual? {
        if let baseExercise = ExerciseController.shared.findExerciseFromWorkoutExercise(workoutExercise) {
            let copy = WorkoutExerciseActual(exercise: baseExercise)
            
            copy.restTime = workoutExercise.restTime
            
            if let exerciseSets = workoutExercise.sets?.array as? [ExerciseSet] {
                var exerciseSetsCopy: [ExerciseSetActual] = []
                for exerciseSet in exerciseSets {
                    exerciseSetsCopy.append(ExerciseSetActual(reps: Int(exerciseSet.reps), weight: Int(exerciseSet.weight)))
                }
                copy.sets = NSOrderedSet(array: exerciseSetsCopy)
            }
            
            return copy
        }
        
        return nil
    }
    
}
