//
//  ExerciseSetController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/29/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class ExerciseSetController {
    
    // MARK: - Class Properties
    
    static let shared = ExerciseSetController()
    static let setComplete = Notification.Name(rawValue:"setComplete")
    static let setNotComplete = Notification.Name(rawValue: "setNotComplete")
    
    // MARK: - Methods
    
    func toggleIsComplete(set: ExerciseSetActual) {
        set.isCompleted = !set.isCompleted
        if set.isCompleted {
            NotificationCenter.default.post(name: ExerciseSetController.setComplete, object: nil)
        } else {
            NotificationCenter.default.post(name: ExerciseSetController.setNotComplete, object: nil)
        }
    }
    
    func deleteExerciseSet(_ exerciseSet: ExerciseSet) {
        exerciseSet.managedObjectContext?.delete(exerciseSet)
        //FetchedResultsController.shared.save()
    }
    
}
