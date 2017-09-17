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
    @IBOutlet weak var exerciseCategoryCustomSegmentedControl: CustomSegmentedControl!
    
    // MARK: - IBActions
    
    @IBAction func exerciseCategoryCustomSegmentedControlChanged(_ sender: CustomSegmentedControl) {
        ExerciseController.shared.changeExerciseCatetoryTo(selectedSegmentIndex: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    
    @IBAction func cancelBarButtonItemTapped(_ sender: Any) {
        ExerciseListViewController.lastExerciseCategorySelected = exerciseCategoryCustomSegmentedControl.selectedSegmentIndex
        
        for exercise in exercisesSelected {
            exercise.isSelected = false
        }
        exercisesSelected = []
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarButtonItemTapped(_ sender: Any) {
        ExerciseListViewController.lastExerciseCategorySelected = exerciseCategoryCustomSegmentedControl.selectedSegmentIndex
        
        //ExerciseController.shared.exercisesSelected = exercisesSelected
//        WorkoutExerciseController.shared.exercisesSelected = exercisesSelected.flatMap { WorkoutExercise(exercise: $0) }
        var workoutExercises = exercisesSelected.flatMap { WorkoutExercise(exercise: $0) }
        
        guard let selectedWorkoutExercises = WorkoutController.shared.selectedWorkout?.exercises?.array as? [WorkoutExercise] else { return }
        
//        for workoutExercise in selectedWorkoutExercises {
//            if workoutExercises.contains(workoutExercise) {
//                if let index = workoutExercises.index(of: workoutExercise) {
//                    workoutExercises[index] = workoutExercise
//                }
//            }
//        }
        
        for selectedWorkoutExercise in selectedWorkoutExercises {
            for workoutExercise in workoutExercises {
                if selectedWorkoutExercise.id == workoutExercise.id {
                    if let index = workoutExercises.index(of: workoutExercise) {
                        workoutExercises[index] = selectedWorkoutExercise
                    }
                }
            }
        }
        
        WorkoutController.shared.selectedWorkout?.exercises = NSOrderedSet(array: workoutExercises)
//        if let selectedWorkoutName = WorkoutController.shared.selectedWorkout?.name, !selectedWorkoutName.isEmpty {
//            FetchedResultsController.shared.save()
//        }
        ExerciseController.shared.exercisesSelected = exercisesSelected
        exercisesSelected = []

        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Instance Properties
    
    var exercisesSelected: [Exercise] = []
    
    // MARK: - Class Properties
    
    static var lastExerciseCategorySelected = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        exerciseCategoryCustomSegmentedControl.selectedSegmentIndex = ExerciseListViewController.lastExerciseCategorySelected
        exerciseCategoryCustomSegmentedControl.updateSelector()
        
        if let selectedWorkoutExercises = WorkoutController.shared.selectedWorkout?.exercises?.array as? [WorkoutExercise] {
            for workoutExercise in selectedWorkoutExercises {
                for exercise in ExerciseController.shared.exercises {
                    if workoutExercise.id == exercise.id {
                        exercise.isSelected = true
                        exercisesSelected.append(exercise)
                    }
                }
            }
        }
        
        tableView.separatorColor = UIColor(red: 41.0/255.0, green: 35.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        
        
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
        
        cell.textLabel?.textColor = .white
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

