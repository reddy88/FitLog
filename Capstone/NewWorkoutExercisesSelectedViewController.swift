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
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: WorkoutExerciseAddSetTableViewCell.addedSetNotification, object: nil)
        
        tableView.tableFooterView = UIView()
    
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTableView()
    }
    
    // MARK: - Methods
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurveRaw = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRaw),
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        view.layoutIfNeeded()
        tableViewBottomConstraint.constant = keyboardFrame.size.height
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        view.layoutIfNeeded()
        
        UIView.commitAnimations()
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurveRaw = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRaw) else { return }
        
        view.layoutIfNeeded()
        tableViewBottomConstraint.constant = 0
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        view.layoutIfNeeded()
        
        UIView.commitAnimations()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension NewWorkoutExercisesSelectedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutController.shared.selectedWorkout?.exercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "workoutExerciseCell", for: indexPath) as? WorkoutExerciseAddSetTableViewCell {
            let workoutExercise = WorkoutController.shared.selectedWorkout?.exercises?[indexPath.row] as? WorkoutExercise
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension NewWorkoutExercisesSelectedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return WorkoutExerciseController.shared.exercisesSelected[collectionView.tag].sets.count
        if let workoutExercise = WorkoutController.shared.selectedWorkout?.exercises?[collectionView.tag] as? WorkoutExercise {
            return workoutExercise.sets?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetCell", for: indexPath) as? ExerciseAddSetCollectionViewCell else { return ExerciseAddSetCollectionViewCell() }
        //cell.exerciseSet = WorkoutExerciseController.shared.exercisesSelected[collectionView.tag].sets[indexPath.item]
        if let workoutExercise = WorkoutController.shared.selectedWorkout?.exercises?[collectionView.tag] as? WorkoutExercise, let exerciseSet = workoutExercise.sets?[indexPath.item] as? ExerciseSet {
            cell.exerciseSet = exerciseSet
        }
        cell.exerciseSetNumber = indexPath.item + 1
//        cell.updateViews(withExerciseSet: WorkoutExerciseController.shared.exercisesSelected[collectionView.tag].sets[indexPath.item], exerciseSetNumber: indexPath.item + 1)
        return cell
    }
    
}

