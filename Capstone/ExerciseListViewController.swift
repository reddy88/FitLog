//
//  ExerciseListViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/26/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class ExerciseListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exerciseCategorySegmentedControl: UISegmentedControl!
    
    // MARK: - IBActions
    
    @IBAction func exerciseCategorySegmentedControlChanged(_ sender: UISegmentedControl) {
        ExerciseController.shared.changeExerciseCatetoryTo(selectedSegmentIndex: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    @IBAction func cancelBarButtonItemTapped(_ sender: Any) {
        ExerciseListViewController.lastExerciseCategorySelected = exerciseCategorySegmentedControl.selectedSegmentIndex
        
        for exercise in exercisesSelected {
            exercise.isSelected = false
        }
        exercisesSelected = []
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarButtonItemTapped(_ sender: Any) {
        ExerciseListViewController.lastExerciseCategorySelected = exerciseCategorySegmentedControl.selectedSegmentIndex
        
        //ExerciseController.shared.exercisesSelected = exercisesSelected
//        WorkoutExerciseController.shared.exercisesSelected = exercisesSelected.flatMap { WorkoutExercise(exercise: $0) }
        var workoutExercises = exercisesSelected.flatMap { WorkoutExercise(exercise: $0) }
        
        guard let selectedWorkout = WorkoutController.shared.selectedWorkout else { return }
        
        for workoutExercise in selectedWorkout.exercises {
            if workoutExercises.contains(workoutExercise) {
                if let index = workoutExercises.index(of: workoutExercise) {
                    workoutExercises[index] = workoutExercise
                }
            }
        }
        
        WorkoutController.shared.selectedWorkout?.exercises = workoutExercises
        ExerciseController.shared.exercisesSelected = exercisesSelected
        exercisesSelected = []

        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Instance Properties
    
    var exercisesSelected: [Exercise] = []
    
    // MARK: - Class Properties
    
    static var lastExerciseCategorySelected = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        exerciseCategorySegmentedControl.selectedSegmentIndex = ExerciseListViewController.lastExerciseCategorySelected
        
        if let selectedWorkout = WorkoutController.shared.selectedWorkout{
            for workoutExercise in selectedWorkout.exercises {
                for exercise in ExerciseController.shared.exercises {
                    if workoutExercise == exercise {
                        exercise.isSelected = true
                        exercisesSelected.append(exercise)
                    }
                }
            }
        }
        
        //exercisesSelected = ExerciseController.shared.exercisesSelected
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ExerciseListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseController.shared.exercisesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        let exercise = ExerciseController.shared.exercisesToDisplay[indexPath.row]
        
        if exercise.isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exercise = ExerciseController.shared.exercisesToDisplay[indexPath.row]
        
        if exercise.isSelected {
            guard let index = exercisesSelected.index(of: exercise) else { return }
            exercisesSelected.remove(at: index)
        } else {
            exercisesSelected.append(exercise)
        }
        
        exercise.isSelected = !exercise.isSelected
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

