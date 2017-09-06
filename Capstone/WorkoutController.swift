//
//  WorkoutController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/31/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class WorkoutController {
    
    // MARK: - Class Properties
    
    static let shared = WorkoutController()
    
    // MARK: - Instance Properties
    
    var workouts: [Workout] = []
    var todaysWorkouts: [Workout] = []
    var selectedWorkout: Workout?
    
    // MARK: - Methods
    
    func createWorkout(name: String?, tagColor: TagColor, workoutDays: [DayOfWeek], exercises: [WorkoutExercise]) {
        let newWorkout = Workout()
        
        newWorkout.name = name
        newWorkout.tagColor = tagColor
        newWorkout.workoutDays = workoutDays
        newWorkout.exercises = exercises
        
        workouts.append(newWorkout)
    }
    
    func getWorkoutsScheduledForToday() {
        var todaysWorkouts: [Workout] = []
        
        for workout in workouts {
            for day in workout.workoutDays {
                if day.rawValue == Calendar.current.component(.weekday, from: Date()) {
                    todaysWorkouts.append(workout)
                }
            }
        }
        
        self.todaysWorkouts = todaysWorkouts
    }
    
}
