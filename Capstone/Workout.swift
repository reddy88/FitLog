//
//  Workout.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/27/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class Workout {
    
    // MARK: - Properties
    
    var name: String? = nil
    var tagColor: TagColor = .noTag
    var workoutDays: [DayOfWeek] = []
    var exercises: [WorkoutExercise] = []
}

enum TagColor {
    case noTag
    case red
    case orange
    case green
    case lightBlue
    case blue
    case purple
}
