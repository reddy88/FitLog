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
        //shouldStatusBarHide = true
        
        homeViewLeadingConstraint.constant = 250
        homeViewTrailingConstraint.constant = -250
        //        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            //self.statusBarWindow?.alpha = 0.0
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
        

        
        //        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        //shouldStatusBarHide = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()

            //self.statusBarWindow?.alpha = 1.0
            self.setNeedsStatusBarAppearanceUpdate()
            self.homeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        homeViewTapGestureRecognizer.isEnabled = false
        menuButton.isEnabled = true
        
        
    }
    
    
    // MARK: - Properties
    
    let menuItems = ["", "LOG", "WORKOUTS"]
    let menuItemImages = [nil, #imageLiteral(resourceName: "logicon"), #imageLiteral(resourceName: "clipboard")]
    var shouldScrollToBottom = true
    var shouldStatusBarHide = false
    let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EMMMd")
        return formatter
    }()
    
    override var prefersStatusBarHidden: Bool {
        return shouldStatusBarHide
    }
    
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
        
        
//        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: UIApplication.shared.statusBarFrame.size.height))
//        statusView.backgroundColor = UIColor(red: 41.0/255.0, green: 35.0/255.0, blue: 66.0/255.0, alpha: 1.0)
//        self.view.addSubview(statusView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WorkoutController.shared.getWorkoutsScheduledForToday()
        tableView.reloadData()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
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
            WorkoutCompletedController.shared.createPendingWorkoutCompleted(actualWorkout: actualWorkout)
            ActualWorkoutController.shared.selectedWorkout = actualWorkout
        } else if segue.identifier == "toWorkoutsList" {
            
            homeViewLeadingConstraint.constant = 0
            homeViewTrailingConstraint.constant = 0
            
            homeViewTapGestureRecognizer.isEnabled = false
            menuButton.isEnabled = true
            //shouldStatusBarHide = false
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            if indexPath.row == 2 {
                
                performSegue(withIdentifier: "toWorkoutsList", sender: nil)
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout?.exercises?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let workoutExercise = WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout?.exercises?[section] as? WorkoutExerciseActual, let count = workoutExercise.sets?.count {
            return count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetsSectionNameCell", for: indexPath) as? ExerciseSetsSectionNameCollectionViewCell,
                let workoutExercise = WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout?.exercises?[indexPath.section] as? WorkoutExerciseActual else { return ExerciseSetsSectionNameCollectionViewCell() }
            
            cell.exerciseNameLabel.text = workoutExercise.name
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetsCell", for: indexPath) as? ExerciseSetsCollectionViewCell,
            let workoutExercise = WorkoutCompletedController.shared.workoutsCompleted[collectionView.tag].actualWorkout?.exercises?[indexPath.section] as? WorkoutExerciseActual,
            let exerciseSet = workoutExercise.sets?[indexPath.item - 1] as? ExerciseSetActual else { return ExerciseSetsCollectionViewCell() }
        cell.setNumberLabel.text = "\(indexPath.item)"
        cell.updateViews(set: exerciseSet)
        return cell
    }
    
}
