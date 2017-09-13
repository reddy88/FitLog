//
//  WorkoutExercise.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/28/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation
import CoreData

extension WorkoutExercise {
    
    // MARK: - Initializers
    
    convenience init(exercise: Exercise, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.sets = []
        self.restTime = 0
        self.name = exercise.name
        self.category = exercise.category
        self.id = exercise.id
    }
    
    convenience init(workoutExercise: WorkoutExercise, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        if let exerciseSets = workoutExercise.sets?.array as? [ExerciseSet] {
            var exerciseSetsCopy: [ExerciseSet] = []
            for exerciseSet in exerciseSets {
                exerciseSetsCopy.append(ExerciseSet(reps: Int(exerciseSet.reps), weight: Int(exerciseSet.weight)))
            }
            self.sets = NSOrderedSet(array: exerciseSetsCopy)
        }
        
        self.restTime = workoutExercise.restTime
        self.name = workoutExercise.name
        self.category = workoutExercise.category
        self.id = workoutExercise.id
    }

}
