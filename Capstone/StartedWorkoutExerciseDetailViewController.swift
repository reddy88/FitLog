//
//  StartedWorkoutExerciseDetailViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/4/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class StartedWorkoutExerciseDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var restTimeProgressView: UIProgressView!
    @IBOutlet weak var restTimerLabel: UILabel!
    
    // MARK: - Properties
    
    var workoutExercise: WorkoutExerciseActual?
    var timerStringFromOverview: String?
    var startTime: Date?
    var restTimer = Timer()
    var restTime: Int?
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        if let date = WorkoutCompletedController.shared.pendingWorkoutCompleted?.date {
            startTime = date as Date
        }
        timerLabel.text = timerStringFromOverview
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimerLabel), name: WorkoutTimer.workoutTimerFired, object: nil)
        if let restTime = workoutExercise?.restTime {
            self.restTime = Int(restTime)
        }
        restTimerLabel.text = "\(workoutExercise?.restTime ?? 0)"
        NotificationCenter.default.addObserver(self, selector: #selector(startRestTimer), name: ExerciseSetController.setComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopRestTimer), name: ExerciseSetController.setNotComplete, object: nil)
        
        title = workoutExercise?.name
        
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
    
    func startRestTimer() {
        guard let restTime = restTime else { return }
        if restTime > 0 {
            restTimeProgressView.alpha = 1
            restTimerLabel.alpha = 1
            restTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRestTimerLabel), userInfo: nil, repeats: true)
            restTimer.tolerance = 0.5
        }
    }
    
    func stopRestTimer() {
        restTimer.invalidate()
        restTimeProgressView.alpha = 0
        restTimeProgressView.progress = 1
        restTimerLabel.alpha = 0
        restTimerLabel.text = "\(workoutExercise?.restTime ?? 0)"
        if let restTime = workoutExercise?.restTime {
            self.restTime = Int(restTime)
        }
    }
    
    func updateRestTimerLabel() {
        guard var restTime = restTime, restTime > 0, let setRestTime = workoutExercise?.restTime else {
            stopRestTimer()
            return
        }
        restTime -= 1
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
            self.restTimeProgressView.setProgress(Float(restTime) / Float(setRestTime), animated: true)
        }, completion: nil)
        restTimerLabel.text = "\(restTime)"
        self.restTime = restTime
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension StartedWorkoutExerciseDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutExercise?.sets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "startedWorkoutSetDetailCell", for: indexPath) as? StartedWorkoutSetDetailTableViewCell,
            let exerciseSet = workoutExercise?.sets?[indexPath.row] as? ExerciseSetActual else { return StartedWorkoutSetDetailTableViewCell() }
        cell.delegate = self
        cell.setNumberLabel.text = "Set #\(indexPath.row + 1)"
        cell.exerciseSet = exerciseSet
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let exerciseSet = workoutExercise?.sets?[indexPath.row] as? ExerciseSetActual {
            if exerciseSet.isCompleted {
                return 75
            }
        }
        
        return 225
    }
    
}

// MARK: - StartedWorkoutSetDetailTableViewCellDelegate

extension StartedWorkoutExerciseDetailViewController: StartedWorkoutSetDetailTableViewCellDelegate {
    func setCompleteButtonTapped(cell: StartedWorkoutSetDetailTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let workoutExercise = workoutExercise,
            let exerciseSet = workoutExercise.sets?[indexPath.row] as? ExerciseSetActual else { return }
        ExerciseSetController.shared.toggleIsComplete(set: exerciseSet)
        cell.updateViews()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
