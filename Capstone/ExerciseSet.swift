//
//  ExerciseSet.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/28/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class ExerciseSet {
    
    // MARK: - Properties
    
    var reps: Int?
    var weight: Int?
    
    init(reps: Int? = nil, weight: Int? = nil) {
        self.reps = reps
        self.weight = weight
    }
    
}
