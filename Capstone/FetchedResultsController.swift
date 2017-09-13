//
//  FetchedResultsController.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/13/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation
import CoreData

class FetchedResultsController {
    
    static let shared = FetchedResultsController()
    
    let fetchedWorkoutCompletedController: NSFetchedResultsController<WorkoutCompleted> = {
        let fetchRequest: NSFetchRequest<WorkoutCompleted> = WorkoutCompleted.fetchRequest()
        fetchRequest.sortDescriptors = []
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    let fetchedWorkoutController: NSFetchedResultsController<Workout> = {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        fetchRequest.sortDescriptors = []
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    
    init() {
        do {
            try fetchedWorkoutCompletedController.performFetch()
            try fetchedWorkoutController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error)
        }
    }
    
}
