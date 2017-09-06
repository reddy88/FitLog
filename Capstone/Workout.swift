//
//  Workout.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/27/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class Workout: Cloneable {
    
    // MARK: - Properties
    
    var name: String? = nil
    var tagColor: TagColor = .noTag
    var workoutDays: [DayOfWeek] = []
    var exercises: [WorkoutExercise] = []
    
    // MARK: - Initializers
    
    init() {}
    
    // MARK: - Cloneable
    
    required init(instance: Workout) {
        self.name = instance.name
        self.tagColor = instance.tagColor
        self.workoutDays = instance.workoutDays
        self.exercises = instance.exercises.copy()
    }
    
}

enum TagColor: String {
    case noTag
    case red
    case orange
    case green
    case lightBlue
    case blue
    case purple
}
