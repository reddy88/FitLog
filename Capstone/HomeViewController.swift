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
    @IBOutlet var homeViewTapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - IBActions
    
    @IBAction func menuBarButtonItemTapped(_ sender: Any) {
        
        homeViewTapGestureRecognizer.isEnabled = true
        
        homeViewLeadingConstraint.constant = 300
        homeViewTrailingConstraint.constant = -300
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func homeViewTapped(_ sender: Any) {
        homeViewLeadingConstraint.constant = 0
        homeViewTrailingConstraint.constant = 0
        
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        homeViewTapGestureRecognizer.isEnabled = false
    }
    
    
    // MARK: - Properties
    
    let menuItems = ["Workouts"]
    let menuItemImages = [#imageLiteral(resourceName: "dumbell icon")]
    var shouldScrollToBottom = true
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EMMMd")
        return formatter
    }()
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        homeViewTapGestureRecognizer.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WorkoutController.shared.getWorkoutsScheduledForToday()
        tableView.reloadData()
        
        if shouldScrollToBottom {
            shouldScrollToBottom = !shouldScrollToBottom
            
            if WorkoutController.shared.todaysWorkouts.count == 0 {
                if WorkoutCompletedController.shared.workoutsCompleted.count != 0 {
                    let indexPath = IndexPath(row: WorkoutCompletedController.shared.workoutsCompleted.count - 1, section: 0)
                    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            } else {
                let indexPath = IndexPath(row: WorkoutController.shared.todaysWorkouts.count - 1, section: 1)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startWorkout" {
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            
            let actualWorkout = ActualWorkoutController.shared.copyWorkout(WorkoutController.shared.todaysWorkouts[row])
            WorkoutCompletedController.shared.createPendingWorkoutCompleted(plannedWorkout: WorkoutController.shared.todaysWorkouts[row], actualWorkout: actualWorkout)
            ActualWorkoutController.shared.selectedWorkout = actualWorkout
        } else if segue.identifier == "toWorkoutsList" {
            navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
            
            homeViewLeadingConstraint.constant = 0
            homeViewTrailingConstraint.constant = 0
            
            homeViewTapGestureRecognizer.isEnabled = false
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
                return 81
            }
            return 220
        }
        
        return 75
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.white
        }
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 41.0/255.0, green: 35.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    }
    
    //    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    //        if indexPath.section ==
    //        return false
    //    }
    
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
