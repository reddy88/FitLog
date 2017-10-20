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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var homeView: UIView!
    
    // MARK: - IBActions
    
    @IBAction func menuBarButtonItemTapped(_ sender: Any) {
        
        homeViewTapGestureRecognizer.isEnabled = true
        menuButton.isEnabled = false
        
        homeViewLeadingConstraint.constant = 250
        homeViewTrailingConstraint.constant = -250
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
            self.homeView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            self.homeView.layer.shadowColor = UIColor.white.cgColor
            self.homeView.layer.shadowOpacity = 1
            self.homeView.layer.shadowOffset = CGSize.zero
            self.homeView.layer.shadowRadius = 1
        })
    }
    
    @IBAction func homeViewTapped(_ sender: Any) {
        homeViewLeadingConstraint.constant = 0
        homeViewTrailingConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
            self.setNeedsStatusBarAppearanceUpdate()
            self.homeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        homeViewTapGestureRecognizer.isEnabled = false
        menuButton.isEnabled = true
    }
    
    // MARK: - Properties
    
    let menuItems = ["", "LOG", "CHARTS","CALENDAR", "WORKOUTS"]
    let menuItemImages = [nil, #imageLiteral(resourceName: "logicon"), #imageLiteral(resourceName: "charticon"), #imageLiteral(resourceName: "calendaricon"), #imageLiteral(resourceName: "clipboard")]
    var shouldScrollToBottom = true
    var last10 = [WorkoutCompleted]()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EMMMd")
        return formatter
    }()
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let count = WorkoutCompletedController.shared.workoutsCompleted.count
        if count < 10 {
            last10 = WorkoutCompletedController.shared.workoutsCompleted
        } else {
            last10 = Array(WorkoutCompletedController.shared.workoutsCompleted[count - 11...count - 1])
        }
        
        tableView.reloadData()
        
        if shouldScrollToBottom {
            shouldScrollToBottom = !shouldScrollToBottom
            
            if WorkoutController.shared.todaysWorkouts.count == 0 {
                let indexPath = IndexPath(row: 0, section: 1)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
            WorkoutCompletedController.shared.createPendingWorkoutCompleted(actualWorkout: actualWorkout)
            ActualWorkoutController.shared.selectedWorkout = actualWorkout
        } else if segue.identifier == "toWorkoutsList" || segue.identifier == "toLog" || segue.identifier == "toCalendar" || segue.identifier == "toChartsExercises" {
            
            homeViewLeadingConstraint.constant = 0
            homeViewTrailingConstraint.constant = 0
            
            homeViewTapGestureRecognizer.isEnabled = false
            menuButton.isEnabled = true
            
            navigationController?.setNavigationBarHidden(false, animated: false)
            self.homeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
            if last10.count == 0 {
                return 1
            } else {
                return last10.count * 2
            }
        }
        if WorkoutController.shared.todaysWorkouts.count == 0 {
            return 1
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
            if last10.count == 0 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "noRecentCell", for: indexPath)
                cell.textLabel?.text = "You have no recent workouts. What are you waiting for? Get to it!"
                return cell
            } else if indexPath.row % 2 == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleWithDateCell", for: indexPath) as? WorkoutTitleWithDateTableViewCell,
                    let actualWorkout = last10[indexPath.row / 2].actualWorkout,
                    let date = last10[indexPath.row / 2].date else { return WorkoutTitleWithDateTableViewCell() }
                cell.updateViews(workout: actualWorkout, dateAsString: dateFormatter.string(from: date as Date), time: last10[indexPath.row / 2].time)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as? WorkoutExercisesTableViewCell else { return WorkoutExercisesTableViewCell() }
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row / 2)
                return cell
            }
        }
        
        if WorkoutController.shared.todaysWorkouts.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noRecentCell", for: indexPath)
            cell.textLabel?.text = "No workouts scheduled."
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as? WorkoutTitleTableViewCell else { return WorkoutTitleTableViewCell() }
        cell.updateViews(workout: WorkoutController.shared.todaysWorkouts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return 70
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
            return "Recent Workouts"
        }
        
        return "Today's Scheduled Workout(s)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.white
        }
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 41.0/255.0, green: 35.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            if indexPath.row == 1 {
                performSegue(withIdentifier: "toLog", sender: nil)
            } else if indexPath.row == 2 {
                performSegue(withIdentifier: "toChartsExercises", sender: nil)
            } else if indexPath.row == 3 {
                performSegue(withIdentifier: "toCalendar", sender: nil)
            } else if indexPath.row == 4 {
                performSegue(withIdentifier: "toWorkoutsList", sender: nil)
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return last10[collectionView.tag].actualWorkout?.exercises?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let workoutExercise = last10[collectionView.tag].actualWorkout?.exercises?[section] as? WorkoutExerciseActual, let count = workoutExercise.sets?.count {
            return count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetsSectionNameCell", for: indexPath) as? ExerciseSetsSectionNameCollectionViewCell,
                let workoutExercise = last10[collectionView.tag].actualWorkout?.exercises?[indexPath.section] as? WorkoutExerciseActual else { return ExerciseSetsSectionNameCollectionViewCell() }
            
            cell.exerciseNameLabel.text = workoutExercise.name
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetsCell", for: indexPath) as? ExerciseSetsCollectionViewCell,
            let workoutExercise = last10[collectionView.tag].actualWorkout?.exercises?[indexPath.section] as? WorkoutExerciseActual,
            let exerciseSet = workoutExercise.sets?[indexPath.item - 1] as? ExerciseSetActual else { return ExerciseSetsCollectionViewCell() }
        cell.setNumberLabel.text = "\(indexPath.item)"
        cell.updateViews(set: exerciseSet)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation == .landscapeLeft ||  UIDevice.current.orientation == .landscapeRight {
            return CGSize(width: UIScreen.main.bounds.width / 4.0 - 15.0, height: 29.0)
        }
        return CGSize(width: UIScreen.main.bounds.width / 2.0 - 15.0, height: 29.0)
    }
    
}
