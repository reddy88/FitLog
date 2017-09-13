//
//  HomeViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/3/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var homeViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    
    @IBAction func menuBarButtonItemTapped(_ sender: Any) {
        if isMenuOpened {
            homeViewLeadingConstraint.constant = 0
            homeViewTrailingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            homeViewLeadingConstraint.constant = 300
            homeViewTrailingConstraint.constant = -300
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.layoutIfNeeded()
            })
        }
        
        isMenuOpened = !isMenuOpened
    }
    
    // MARK: - Properties
    
    var isMenuOpened = false
    let menuItems = ["Workouts"]
    let menuItemImages = [#imageLiteral(resourceName: "dumbell icon")]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EMMMd")
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WorkoutController.shared.getWorkoutsScheduledForToday()
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startWorkout" {
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            
            let actualWorkout = WorkoutController.shared.copyWorkout(WorkoutController.shared.todaysWorkouts[row])
            WorkoutCompletedController.shared.createPendingWorkoutCompleted(plannedWorkout: WorkoutController.shared.todaysWorkouts[row], actualWorkout: actualWorkout)
            WorkoutController.shared.selectedWorkout = actualWorkout
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 1 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return menuItems.count
        }
        if section == 0 {
            return WorkoutCompletedController.shared.workoutsCompleted.count * 2
        }
        return WorkoutController.shared.todaysWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath) as? MenuItemTableViewCell else { return MenuItemTableViewCell() }
            cell.menuItemLabel.text = menuItems[indexPath.row]
            cell.menuItemImageView.image = menuItemImages[indexPath.row]
            return cell
        }

        if indexPath.section == 0 {
            if indexPath.row % 2 == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleWithDateCell", for: indexPath) as? WorkoutTitleWithDateTableViewCell,
                    let actualWorkout = WorkoutCompletedController.shared.workoutsCompleted[indexPath.row / 2].actualWorkout,
                    let date = WorkoutCompletedController.shared.workoutsCompleted[indexPath.row / 2].date else { return WorkoutTitleWithDateTableViewCell() }
                cell.updateViews(workout: actualWorkout, dateAsString: dateFormatter.string(from: date as Date))
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as? WorkoutExercisesTableViewCell else { return WorkoutExercisesTableViewCell() }
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row / 2)
                return cell
            }
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as? WorkoutTitleTableViewCell else { return WorkoutTitleTableViewCell() }
        cell.updateViews(workout: WorkoutController.shared.todaysWorkouts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return 44
        }
        
        if indexPath.section == 0 {
            if indexPath.row % 2 == 0 {
                return 70
            }
            return 220
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1 {
            return nil
        }
        
        if section == 0 {
            return "Previous Workouts"
        }
        
        return "Today's Scheduled Workout(s)"
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout?.exercises?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let workoutExercise = WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout?.exercises?[section] as? WorkoutExercise, let count = workoutExercise.sets?.count {
            return count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetsSectionNameCell", for: indexPath) as? ExerciseSetsSectionNameCollectionViewCell,
                let workoutExercise = WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout?.exercises?[indexPath.section] as? WorkoutExercise else { return ExerciseSetsSectionNameCollectionViewCell() }
            
            cell.exerciseNameLabel.text = workoutExercise.name
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetsCell", for: indexPath) as? ExerciseSetsCollectionViewCell,
            let workoutExercise = WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout?.exercises?[indexPath.section] as? WorkoutExercise,
            let exerciseSet = workoutExercise.sets?[indexPath.item - 1] as? ExerciseSet else { return ExerciseSetsCollectionViewCell() }
        cell.setNumberLabel.text = "\(indexPath.item)"
        cell.updateViews(set: exerciseSet)
        return cell
    }
    
}
