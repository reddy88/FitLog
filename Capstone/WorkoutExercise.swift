//
//  WorkoutExercise.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/28/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class WorkoutExercise: Exercise {
    
    // MARK: - Properties
    
    var sets: [ExerciseSet]
    var restTime: Int
    
    // MARK: - Initializers
    
    init(exercise: Exercise) {
        self.sets = []
        self.restTime = 0
        
        super.init(name: exercise.name, category: exercise.category, id: exercise.id)
    }
    
}
