//
//  NewWorkoutPageViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/29/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class NewWorkoutPageViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - IBActions
    
    @IBAction func saveBarButtonItemTapped(_ sender: Any) {
        if let viewControllers = pageContainer.viewControllers {
            
            for viewController in viewControllers {
                if let viewController = viewController as? NewWorkoutViewController {
                    
                    guard let workoutNameTableViewCell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? WorkoutNameTableViewCell,
                        let nameFromTextField = workoutNameTableViewCell.workoutNameTextField.text, !nameFromTextField.isEmpty else { return }
                    
                    WorkoutController.shared.selectedWorkout?.name = nameFromTextField
                    
                    guard let colorTagTableViewCell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ColorTagTableViewCell else { return }
                    let tagColorFromCell = colorTagTableViewCell.colorTagSelected()
                    
                    WorkoutController.shared.selectedWorkout?.tagColor = tagColorFromCell.rawValue
                    
                    guard let daysOfWeekTableViewCell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? DaysOfWeekTableViewCell else { return }
                    let daysSelectedFromCell = daysOfWeekTableViewCell.daysSelected()
                    
                    WorkoutController.shared.daysOfWeekConverter(daysOfWeek: daysSelectedFromCell, workout: WorkoutController.shared.selectedWorkout)
                }
            }
            
            guard let workout = WorkoutController.shared.selectedWorkout else { return }
            if WorkoutController.shared.isValidWorkout(workout: workout) {
                emptyExercisesSelected()
                FetchedResultsController.shared.save()
                navigationController?.popViewController(animated: true)
            } else {
                return
            }
        
        }
    }
    
    // MARK: - Properties
    
    let pages = ["newWorkoutViewController", "newWorkoutExercisesSelectedViewController"]
    var pageContainer: UIPageViewController!
    var isNewWorkout: Bool = false
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        if let startingViewController = storyboard?.instantiateViewController(withIdentifier: pages[0]) {
            pageContainer.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageContainer.view)
        view.bringSubview(toFront: pageControl)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if isNewWorkout {
            title = "New Workout"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonItemTapped))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParentViewController {
            emptyExercisesSelected()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        let pageContainerViewTopConstraint = NSLayoutConstraint(item: topLayoutGuide, attribute: .bottom, relatedBy: .equal, toItem: pageContainer.view, attribute: .top, multiplier: 1.0, constant: 0)
        let pageContainerViewLeadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: pageContainer.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let pageContainerViewTrailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: pageContainer.view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let pageContainerViewBottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: pageContainer.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        view.layoutIfNeeded()
        pageContainer.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([pageContainerViewTopConstraint,pageContainerViewLeadingConstraint,pageContainerViewTrailingConstraint,pageContainerViewBottomConstraint])
    }
    
    // MARK: - Methods
    
    func emptyExercisesSelected() {
        for exercise in ExerciseController.shared.exercisesSelected {
            exercise.isSelected = false
        }
        ExerciseController.shared.exercisesSelected = []
    }
    
    func cancelBarButtonItemTapped() {
        WorkoutController.shared.workouts.removeLast()
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension NewWorkoutPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    return storyboard?.instantiateViewController(withIdentifier: pages[index - 1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return storyboard?.instantiateViewController(withIdentifier: pages[index + 1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (finished && completed) {
            if previousViewControllers[0].isKind(of: NewWorkoutViewController.self) {
                navigationItem.rightBarButtonItem = nil
                pageControl.currentPage = 1
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveBarButtonItemTapped))
                pageControl.currentPage = 0
//                navigationItem.rightBarButtonItem?.title = "Save"
//                navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
        }
    }
    
    
    
}
