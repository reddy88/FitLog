//
//  ActualWorkoutController.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/13/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class ActualWorkoutController {
    
    // MARK: - Class Properties
    
    static let shared = ActualWorkoutController()
    
    // MARK: - Instance Properties
    
    var actualWorkouts: [ActualWorkout] = []
    var selectedWorkout: ActualWorkout?
    
    // MARK: - Methods
    
    func daysOfWeekConverterToArray(workout: ActualWorkout) -> [DayOfWeek] {
        var daysOfWeek: [DayOfWeek] = []
        
        if workout.sunday == true {
            daysOfWeek.append(.sunday)
        }
        if workout.monday == true {
            daysOfWeek.append(.monday)
        }
        if workout.tuesday == true {
            daysOfWeek.append(.tuesday)
        }
        if workout.wednesday == true {
            daysOfWeek.append(.wednesday)
        }
        if workout.thursday == true {
            daysOfWeek.append(.thursday)
        }
        if workout.friday == true {
            daysOfWeek.append(.friday)
        }
        if workout.saturday == true {
            daysOfWeek.append(.saturday)
        }
        
        return daysOfWeek
    }
    
    func copyWorkout(_ workout: Workout) -> ActualWorkout {
        let workoutCopy = ActualWorkout(name: workout.name)
        workoutCopy.sunday = workout.sunday
        workoutCopy.monday = workout.monday
        workoutCopy.tuesday = workout.tuesday
        workoutCopy.wednesday = workout.wednesday
        workoutCopy.thursday = workout.thursday
        workoutCopy.friday = workout.friday
        workoutCopy.saturday = workout.saturday
        workoutCopy.tagColor = workout.tagColor
        
        if let workoutExercises = workout.exercises?.array as? [WorkoutExercise] {
            var workoutExercisesCopy: [WorkoutExerciseActual] = []
            for workoutExercise in workoutExercises {
                if let copiedWorkoutExercise = WorkoutExerciseController.shared.copyWorkoutExercise(workoutExercise) {
                    workoutExercisesCopy.append(copiedWorkoutExercise)
                }
            }
            workoutCopy.exercises = NSOrderedSet(array: workoutExercisesCopy)
        }
        
        return workoutCopy
    }
    
}
