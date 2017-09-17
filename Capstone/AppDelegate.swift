//
//  AppDelegate.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/26/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ExerciseController.shared.getExercises {
        }
        
        
        
        if let workoutsCompleted = FetchedResultsController.shared.fetchedWorkoutCompletedController.fetchedObjects {
            
            for workoutCompleted in workoutsCompleted {
                if WorkoutCompletedController.shared.isValidWorkoutCompleted(workoutCompleted) {
                    WorkoutCompletedController.shared.workoutsCompleted.append(workoutCompleted)
                } else {
                    WorkoutCompletedController.shared.deleteWorkoutCompleted(workoutCompleted)
                }
            }
        }
        
        if let workouts = FetchedResultsController.shared.fetchedWorkoutController.fetchedObjects {
            WorkoutController.shared.workouts = workouts
        }
        
        UINavigationBar.appearance().barStyle = .blackOpaque
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        return true
    }
    
}
