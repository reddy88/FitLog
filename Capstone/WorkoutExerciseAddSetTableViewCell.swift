//
//  WorkoutExerciseAddSetTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/29/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutExerciseAddSetTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var addSetButton: UIButton!
    @IBOutlet weak var workoutExerciseNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    
    @IBAction func addSetButtonTapped(_ sender: UIButton) {
        let buttonRow = sender.tag
        
        guard let workoutExercise = WorkoutController.shared.selectedWorkout?.exercises?[buttonRow] as? WorkoutExercise, var sets = workoutExercise.sets?.array as? [ExerciseSet] else { return }
        sets.append(ExerciseSet(reps: nil, weight: nil))
        workoutExercise.sets = NSOrderedSet(array: sets)
        collectionView.reloadData()
        NotificationCenter.default.post(name: WorkoutExerciseAddSetTableViewCell.addedSetNotification, object: nil)
        
//        if let workoutExercise = workoutExercise {
//            let newSet = ExerciseSet(reps: 0, weight: 0)
//            workoutExercise.sets.append(newSet)
//            collectionView.reloadData()
//            NotificationCenter.default.post(name: WorkoutExerciseAddSetTableViewCell.addedSetNotification, object: nil)
//        }
    }
    
    @IBAction func removeSetButtonTapped(_ sender: Any) {
        guard var sets = workoutExercise?.sets?.array as? [ExerciseSet] else { return }
        if !sets.isEmpty {
            sets.removeLast()
            workoutExercise?.sets = NSOrderedSet(array: sets)
            collectionView.reloadData()
            NotificationCenter.default.post(name: WorkoutExerciseAddSetTableViewCell.addedSetNotification, object: nil)
        }
    }
    
    @IBAction func restTimerSetButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Rest Time Between Sets In Seconds (Default: 0)", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "secs"
            textfield.keyboardType = .numberPad
            if let restTime = self.workoutExercise?.restTime {
                if restTime == 0 {
                    textfield.text = ""
                } else {
                    textfield.text = "\(restTime)"
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty, let seconds = Int(text) else { return }
            self.workoutExercise?.restTime = Int16(seconds)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Class Properties
    
    static let addedSetNotification = Notification.Name("AddedSet")
    
    // MARK: - Instance Properties
    
    var workoutExercise: WorkoutExercise? {
        didSet {
            updateViews()
        }
    }
//    var exerciseSets: [ExerciseSet] = [] {
//        didSet {
//            NotificationCenter.default.post(name: WorkoutExerciseAddSetTableViewCell.addedSetNotification, object: nil)
//        }
//    }
    
    
    // MARK: - Methods

    func updateViews() {
        workoutExerciseNameLabel.text = workoutExercise?.name
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

//extension WorkoutExerciseAddSetTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return workoutExercise?.sets.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetCell", for: indexPath) as? ExerciseAddSetCollectionViewCell,
//            let set = workoutExercise?.sets[indexPath.item] else { return ExerciseAddSetCollectionViewCell() }
//        cell.updateViews(withExerciseSet: set, exerciseSetNumber: indexPath.item + 1)
//        return cell
//    }
//    
//}
