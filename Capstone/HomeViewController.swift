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
            let actualWorkout = WorkoutController.shared.todaysWorkouts[row].copy()
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
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleWithDateCell", for: indexPath) as? WorkoutTitleWithDateTableViewCell else { return WorkoutTitleWithDateTableViewCell() }
                cell.updateViews(workout: WorkoutCompletedController.shared.workoutsCompleted[indexPath.row / 2].actualWorkout, dateAsString: dateFormatter.string(from: WorkoutCompletedController.shared.workoutsCompleted[indexPath.row / 2].date))
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
        return WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout.exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout.exercises[section].sets.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetsSectionNameCell", for: indexPath) as? ExerciseSetsSectionNameCollectionViewCell else { return ExerciseSetsSectionNameCollectionViewCell() }
            cell.exerciseNameLabel.text = WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout.exercises[indexPath.section].name
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetsCell", for: indexPath) as? ExerciseSetsCollectionViewCell else { return ExerciseSetsCollectionViewCell() }
        cell.setNumberLabel.text = "\(indexPath.item)"
        cell.updateViews(set: WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout.exercises[indexPath.section].sets[indexPath.item - 1])
        return cell
    }
    
}
