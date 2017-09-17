//
//  StartedWorkoutOverviewViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/3/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class StartedWorkoutOverviewViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func cancelBarButtonItemTapped(_ sender: Any) {
        WorkoutTimer.shared.stopTimer()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBarButtonItemTapped(_ sender: Any) {
        
        guard let pendingWorkoutCompleted = WorkoutCompletedController.shared.pendingWorkoutCompleted,
            let workoutExercises = pendingWorkoutCompleted.actualWorkout?.exercises?.array as? [WorkoutExerciseActual],
            let time = pendingWorkoutCompleted.date?.timeIntervalSinceNow else { return }
        
        for workoutExercise in workoutExercises {
            if let exerciseSets = workoutExercise.sets?.array as? [ExerciseSetActual] {
                for exerciseSet in exerciseSets {
                    if !exerciseSet.isCompleted {
                        return
                    }
                }
            }
        }

        pendingWorkoutCompleted.time = -time
        WorkoutCompletedController.shared.addWorkoutCompleted(pendingWorkoutCompleted)
        WorkoutCompletedController.shared.pendingWorkoutCompleted = nil
        WorkoutTimer.shared.stopTimer()
        FetchedResultsController.shared.save()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    var startTime: Date?
    
    let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView()
        
        title = ActualWorkoutController.shared.selectedWorkout?.name?.uppercased()
        
        startTime = WorkoutCompletedController.shared.pendingWorkoutCompleted?.date as Date?
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimerLabel), name: WorkoutTimer.workoutTimerFired, object: nil)
        WorkoutTimer.shared.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExerciseDetail" {
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            let startedWorkoutExerciseDetailViewController = segue.destination as? StartedWorkoutExerciseDetailViewController
            startedWorkoutExerciseDetailViewController?.workoutExercise = ActualWorkoutController.shared.selectedWorkout?.exercises?[row] as? WorkoutExerciseActual
            startedWorkoutExerciseDetailViewController?.timerStringFromOverview = timerLabel.text
        }
    }
    
    // MARK: - Methods
    
    func updateTimerLabel() {
        let currentTime = Date()
        
        guard let startTime = startTime, let hoursDifference = Calendar.current.dateComponents([.hour], from: startTime, to: currentTime).hour, let timeDifferenceString = dateComponentsFormatter.string(from: startTime, to: currentTime) else { return }
    
        if  hoursDifference < 10 {
            timerLabel.text = "0" + timeDifferenceString
        } else {
            timerLabel.text = timeDifferenceString
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension StartedWorkoutOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActualWorkoutController.shared.selectedWorkout?.exercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "startedWorkoutExerciseCell", for: indexPath) as? StartedWorkoutExerciseTableViewCell {
            let workoutExercise = ActualWorkoutController.shared.selectedWorkout?.exercises?[indexPath.row] as? WorkoutExerciseActual
            cell.workoutExercise = workoutExercise
            cell.frame = tableView.bounds
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            cell.layoutIfNeeded()
            cell.collectionViewHeightConstraint.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            return cell
        }
        
        return StartedWorkoutExerciseTableViewCell()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension StartedWorkoutOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let workoutExercise = ActualWorkoutController.shared.selectedWorkout?.exercises?[collectionView.tag] as? WorkoutExerciseActual {
            return workoutExercise.sets?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "startedExerciseSetCell", for: indexPath) as? StartedWorkoutSetCollectionViewCell else { return StartedWorkoutSetCollectionViewCell() }
        if let workoutExercise = ActualWorkoutController.shared.selectedWorkout?.exercises?[collectionView.tag] as? WorkoutExerciseActual {
            cell.exerciseSet = workoutExercise.sets?[indexPath.item] as? ExerciseSetActual
        }
        cell.exerciseSetNumber = indexPath.item + 1
        return cell
    }
    
}
