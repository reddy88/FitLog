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
        let newWorkout = Workout(name: name)
        
        newWorkout.name = name
        newWorkout.tagColor = tagColor.rawValue
        daysOfWeekConverter(daysOfWeek: workoutDays, workout: newWorkout)
        newWorkout.exercises = NSOrderedSet(array: exercises)
        
        workouts.append(newWorkout)
    }
    
    func deleteWorkout(workout: Workout) {
        guard let index = workouts.index(of: workout) else { return }
        workouts.remove(at: index)
        workout.managedObjectContext?.delete(workout)
        FetchedResultsController.shared.save()
    }
    
    func getWorkoutsScheduledForToday() {
        var todaysWorkouts: [Workout] = []
        
        for workout in workouts {
            let workoutDays = daysOfWeekConverterToArray(workout: workout)
            for day in workoutDays {
                if day.rawValue == Calendar.current.component(.weekday, from: Date()) {
                    todaysWorkouts.append(workout)
                }
            }
        }
        
        self.todaysWorkouts = todaysWorkouts
    }
    
    func daysOfWeekConverter(daysOfWeek: [DayOfWeek], workout: Workout?) {
        
        workout?.sunday = false
        workout?.monday = false
        workout?.tuesday = false
        workout?.wednesday = false
        workout?.thursday = false
        workout?.friday = false
        workout?.saturday = false
        
        for dayOfWeek in daysOfWeek {
            switch dayOfWeek {
            case .sunday:
                workout?.sunday = true
            case .monday:
                workout?.monday = true
            case .tuesday:
                workout?.tuesday = true
            case .wednesday:
                workout?.wednesday = true
            case .thursday:
                workout?.thursday = true
            case .friday:
                workout?.friday = true
            case .saturday:
                workout?.saturday = true
            }
        }
    }
    
    func daysOfWeekConverterToArray(workout: Workout) -> [DayOfWeek] {
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
    
//    func copyWorkout(_ workout: Workout) -> Workout {
//        let workoutCopy = Workout(name: workout.name)
//        workoutCopy.sunday = workout.sunday
//        workoutCopy.monday = workout.monday
//        workoutCopy.tuesday = workout.tuesday
//        workoutCopy.wednesday = workout.wednesday
//        workoutCopy.thursday = workout.thursday
//        workoutCopy.friday = workout.friday
//        workoutCopy.saturday = workout.saturday
//        workoutCopy.tagColor = workout.tagColor
//        
//        if let workoutExercises = workout.exercises?.array as? [WorkoutExercise] {
//            var workoutExercisesCopy: [WorkoutExercise] = []
//            for workoutExercise in workoutExercises {
//                workoutExercisesCopy.append(WorkoutExercise(workoutExercise: workoutExercise))
//            }
//            workoutCopy.exercises = NSOrderedSet(array: workoutExercisesCopy)
//        }
//        
//        return workoutCopy
//    }
    
    func isValidWorkout(workout: Workout) -> Bool {
        guard let name = workout.name, !name.isEmpty else { return false }
        
        guard let workoutExercises = workout.exercises?.array as? [WorkoutExercise] else { return false }
        
        if !workoutExercises.isEmpty {
            for exercise in workoutExercises {
                if exercise.sets?.count == 0 {
                    return false
                }
                guard let sets = exercise.sets?.array as? [ExerciseSet] else { return false }
                for set in sets {
                    if set.reps == 0 || set.weight == 0 {
                        return false
                    }
                }
            }
        } else { return false }
        
        return true
    }
    
}
