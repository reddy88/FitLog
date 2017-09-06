//
//  NewWorkoutExercisesSelectedViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/29/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class NewWorkoutExercisesSelectedViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: WorkoutExerciseAddSetTableViewCell.addedSetNotification, object: nil)
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTableView()
    }
    
    // MARK: - Methods
    
    func reloadTableView() {
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension NewWorkoutExercisesSelectedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutController.shared.selectedWorkout?.exercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "workoutExerciseCell", for: indexPath) as? WorkoutExerciseAddSetTableViewCell {
            let workoutExercise = WorkoutController.shared.selectedWorkout?.exercises[indexPath.row]
            cell.workoutExercise = workoutExercise
//            cell.collectionView.dataSource = cell
//            cell.collectionView.delegate = cell
//            cell.collectionView.tag = indexPath.row
            cell.addSetButton.tag = indexPath.row
            cell.frame = tableView.bounds
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            cell.layoutIfNeeded()
            cell.collectionViewHeightConstraint.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            return cell
        }

        return WorkoutExerciseAddSetTableViewCell()
    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let cell = cell as? WorkoutExerciseAddSetTableViewCell else { return }
//        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension NewWorkoutExercisesSelectedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return WorkoutExerciseController.shared.exercisesSelected[collectionView.tag].sets.count
        return WorkoutController.shared.selectedWorkout?.exercises[collectionView.tag].sets.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetCell", for: indexPath) as? ExerciseAddSetCollectionViewCell else { return ExerciseAddSetCollectionViewCell() }
        //cell.exerciseSet = WorkoutExerciseController.shared.exercisesSelected[collectionView.tag].sets[indexPath.item]
        cell.exerciseSet = WorkoutController.shared.selectedWorkout?.exercises[collectionView.tag].sets[indexPath.item]
        cell.exerciseSetNumber = indexPath.item + 1
//        cell.updateViews(withExerciseSet: WorkoutExerciseController.shared.exercisesSelected[collectionView.tag].sets[indexPath.item], exerciseSetNumber: indexPath.item + 1)
        return cell
    }
    
}

