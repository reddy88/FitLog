//
//  WorkoutsListViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/31/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutsListViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWorkout" {
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let workout = WorkoutController.shared.workouts[index]
            WorkoutController.shared.selectedWorkout = workout
            
            if let selectedWorkoutExercises = workout.exercises?.array as? [WorkoutExercise] {
                for workoutExercise in selectedWorkoutExercises {
                    for exercise in ExerciseController.shared.exercises {
                        if workoutExercise.id == exercise.id {
                            ExerciseController.shared.exercisesSelected.append(exercise)
                        }
                    }
                }
            }
            
        } else if segue.identifier == "newWorkout" {
            let newWorkoutPageViewController = segue.destination as? NewWorkoutPageViewController
            newWorkoutPageViewController?.isNewWorkout = true
            WorkoutController.shared.createWorkout(name: "", tagColor: .noTag, workoutDays: [], exercises: [])
            let workout = WorkoutController.shared.workouts.last
            WorkoutController.shared.selectedWorkout = workout
        }
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate

extension WorkoutsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutController.shared.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutListTableViewCell else { return WorkoutListTableViewCell() }
        let workout = WorkoutController.shared.workouts[indexPath.row]
        cell.updateWith(workout: workout)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedWorkout = WorkoutController.shared.workouts[indexPath.row]
            WorkoutController.shared.deleteWorkout(workout: deletedWorkout)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
