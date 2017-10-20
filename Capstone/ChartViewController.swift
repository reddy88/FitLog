//
//  ChartViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/11/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit
import DropDown

class ChartViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartLabel: UILabel!
    
    lazy var menuBar: MenuBar = {
        let menuBar = MenuBar()
        menuBar.chartViewController = self
        return menuBar
    }()
    
    var categoriesDictionary = [10: ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]]
    
    var showCategoryTotalCount = true
    var workoutExerciseDictToShow: [Int: [String: Any]]?
    
    let drop = UIDropDown(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupMenuBar()
        
        drop.placeholder = "Chart Options"
        drop.options = ["Total Count", "Number Of Sets"]
        drop.hideOptionsWhenSelect = true
        drop.didSelect { (option, index) in
            self.changeCategoryOption(index: index)
        }
        drop.textColor = .white
        drop.borderColor = .white
        drop.tint = .white
        drop.optionsTextColor = .black
        view.addSubview(drop)
        
        let views: [String: Any] = ["drop": drop]
        let dropHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|-(5)-[drop(200)]", options: [], metrics: nil, views: views)
        let dropVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[drop(30)]-(100)-|", options: [], metrics: nil, views: views)
        
        drop.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(dropHorizontalConstraint)
        view.addConstraints(dropVerticalConstraint)
        
        categoriesDictionary[8] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[12] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[14] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[11] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[9] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[13] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        
        for workoutCompleted in WorkoutCompletedController.shared.workoutsCompleted {
            guard let actualWorkout = workoutCompleted.actualWorkout,
                let actualWorkoutExercises = actualWorkout.exercises?.array as? [WorkoutExerciseActual] else { return }
            
            for actualWorkoutExercise in actualWorkoutExercises {
                switch actualWorkoutExercise.category {
                case 10:
                    guard let absDict = categoriesDictionary[10],
                        var totalCount = absDict["totalCount"] as? Int,
                        var numberOfSets = absDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = absDict["workoutExercises"] as? [Int: [String: Any]],
                        let sets = actualWorkoutExercise.sets?.array as? [ExerciseSetActual] else { return }
                    
                    if var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseSets = actualWorkoutExerciseDict["sets"] as? [Int] {
                        totalCount += 1
                        categoriesDictionary[10]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[10]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        actualWorkoutExerciseSets.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = actualWorkoutExerciseSets
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[10]?["workoutExercises"] = workoutExercises
                    } else {
                        var actualWorkoutExerciseDict = [String: Any]()
                        var setsBest = [Int]()
                        
                        totalCount += 1
                        categoriesDictionary[10]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[10]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        setsBest.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = setsBest
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[10]?["workoutExercises"] = workoutExercises
                    }
                case 8:
                    guard let armDict = categoriesDictionary[8],
                        var totalCount = armDict["totalCount"] as? Int,
                        var numberOfSets = armDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = armDict["workoutExercises"] as? [Int: [String: Any]],
                        let sets = actualWorkoutExercise.sets?.array as? [ExerciseSetActual] else { return }
                    
                    if var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseSets = actualWorkoutExerciseDict["sets"] as? [Int] {
                        totalCount += 1
                        categoriesDictionary[8]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[8]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        actualWorkoutExerciseSets.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = actualWorkoutExerciseSets
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[8]?["workoutExercises"] = workoutExercises
                    } else {
                        var actualWorkoutExerciseDict = [String: Any]()
                        var setsBest = [Int]()
                        
                        totalCount += 1
                        categoriesDictionary[8]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[8]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        setsBest.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = setsBest
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[8]?["workoutExercises"] = workoutExercises
                    }
                case 12:
                    guard let backDict = categoriesDictionary[12],
                        var totalCount = backDict["totalCount"] as? Int,
                        var numberOfSets = backDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = backDict["workoutExercises"] as? [Int: [String: Any]],
                        let sets = actualWorkoutExercise.sets?.array as? [ExerciseSetActual] else { return }
                    
                    if var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseSets = actualWorkoutExerciseDict["sets"] as? [Int] {
                        totalCount += 1
                        categoriesDictionary[12]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[12]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        actualWorkoutExerciseSets.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = actualWorkoutExerciseSets
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[12]?["workoutExercises"] = workoutExercises
                    } else {
                        var actualWorkoutExerciseDict = [String: Any]()
                        var setsBest = [Int]()
                        
                        totalCount += 1
                        categoriesDictionary[12]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[12]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        setsBest.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = setsBest
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[12]?["workoutExercises"] = workoutExercises
                    }
                case 14:
                    guard let calvesDict = categoriesDictionary[14],
                        var totalCount = calvesDict["totalCount"] as? Int,
                        var numberOfSets = calvesDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = calvesDict["workoutExercises"] as? [Int: [String: Any]],
                        let sets = actualWorkoutExercise.sets?.array as? [ExerciseSetActual] else { return }
                    
                    if var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseSets = actualWorkoutExerciseDict["sets"] as? [Int] {
                        totalCount += 1
                        categoriesDictionary[14]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[14]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        actualWorkoutExerciseSets.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = actualWorkoutExerciseSets
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[14]?["workoutExercises"] = workoutExercises
                    } else {
                        var actualWorkoutExerciseDict = [String: Any]()
                        var setsBest = [Int]()
                        
                        totalCount += 1
                        categoriesDictionary[14]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[14]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        setsBest.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = setsBest
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[14]?["workoutExercises"] = workoutExercises
                    }
                case 11:
                    guard let chestDict = categoriesDictionary[11],
                        var totalCount = chestDict["totalCount"] as? Int,
                        var numberOfSets = chestDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = chestDict["workoutExercises"] as? [Int: [String: Any]],
                        let sets = actualWorkoutExercise.sets?.array as? [ExerciseSetActual] else { return }
                    
                    if var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseSets = actualWorkoutExerciseDict["sets"] as? [Int] {
                        totalCount += 1
                        categoriesDictionary[11]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[11]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        actualWorkoutExerciseSets.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = actualWorkoutExerciseSets
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[11]?["workoutExercises"] = workoutExercises
                    } else {
                        var actualWorkoutExerciseDict = [String: Any]()
                        var setsBest = [Int]()
                        
                        totalCount += 1
                        categoriesDictionary[11]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[11]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        setsBest.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = setsBest
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[11]?["workoutExercises"] = workoutExercises
                    }
                case 9:
                    guard let legsDict = categoriesDictionary[9],
                        var totalCount = legsDict["totalCount"] as? Int,
                        var numberOfSets = legsDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = legsDict["workoutExercises"] as? [Int: [String: Any]],
                        let sets = actualWorkoutExercise.sets?.array as? [ExerciseSetActual] else { return }
                    
                    if var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseSets = actualWorkoutExerciseDict["sets"] as? [Int] {
                        totalCount += 1
                        categoriesDictionary[9]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[9]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        actualWorkoutExerciseSets.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = actualWorkoutExerciseSets
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[9]?["workoutExercises"] = workoutExercises
                    } else {
                        var actualWorkoutExerciseDict = [String: Any]()
                        var setsBest = [Int]()
                        
                        totalCount += 1
                        categoriesDictionary[9]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[9]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        setsBest.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = setsBest
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[9]?["workoutExercises"] = workoutExercises
                    }
                case 13:
                    guard let shouldersDict = categoriesDictionary[13],
                        var totalCount = shouldersDict["totalCount"] as? Int,
                        var numberOfSets = shouldersDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = shouldersDict["workoutExercises"] as? [Int: [String: Any]],
                        let sets = actualWorkoutExercise.sets?.array as? [ExerciseSetActual] else { return }
                    
                    if var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseSets = actualWorkoutExerciseDict["sets"] as? [Int] {
                        totalCount += 1
                        categoriesDictionary[13]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[13]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        actualWorkoutExerciseSets.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = actualWorkoutExerciseSets
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[13]?["workoutExercises"] = workoutExercises
                    } else {
                        var actualWorkoutExerciseDict = [String: Any]()
                        var setsBest = [Int]()
                        
                        totalCount += 1
                        categoriesDictionary[13]?["totalCount"] = totalCount
                        numberOfSets += actualWorkoutExerciseSetsCount
                        categoriesDictionary[13]?["numberOfSets"] = numberOfSets
                        
                        var bestSetWeight = 0
                        for set in sets {
                            if Int(set.weight) > bestSetWeight {
                                bestSetWeight = Int(set.weight)
                            }
                        }
                        
                        actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                        setsBest.append(bestSetWeight)
                        actualWorkoutExerciseDict["sets"] = setsBest
                        workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                        categoriesDictionary[13]?["workoutExercises"] = workoutExercises
                    }
                default:
                    break
                }
            }
        }
    }
    
    func setupMenuBar() {
        view.addSubview(menuBar)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[menuBar]|", options: [], metrics: nil, views: ["menuBar": menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[menuBar(50)]", options: [], metrics: nil, views: ["menuBar": menuBar]))
        
        menuBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    func changeCategoryOption(index: Int) {
        if index == 0 {
            showCategoryTotalCount = true
            chartLabel.text = "Total Count"
        } else {
            showCategoryTotalCount = false
            chartLabel.text = "Number of Sets"
        }
        collectionView.reloadData()
    }
    
    func changeExerciseOption(workoutExerciseDict: [Int: [String: Any]]) {
        workoutExerciseDictToShow = workoutExerciseDict
        collectionView.reloadData()
    }
    
}

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pieChartCell", for: indexPath) as? PieChartCollectionViewCell else { return PieChartCollectionViewCell() }
            cell.updateViews(statsDictionary: categoriesDictionary, showCategoryTotalCount: showCategoryTotalCount)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chartCell", for: indexPath) as? BarChartCollectionViewCell else { return BarChartCollectionViewCell() }
        cell.updateViews(statsDictionary: workoutExerciseDictToShow)
        return cell
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
        if index == 0 {
            if showCategoryTotalCount {
                chartLabel.text = "Total Count"
            } else {
                chartLabel.text = "Number of Sets"
            }
            drop.placeholder = "Chart Options"
            drop.options = ["Total Count", "Number Of Sets"]
            drop.hideOptionsWhenSelect = true
            drop.didSelect { (option, index) in
                self.changeCategoryOption(index: index)
            }
            drop.textColor = .white
            drop.borderColor = .white
            drop.tint = .white
            drop.optionsTextColor = .black
            let _ = drop.resign()
        } else {
            chartLabel.text = "Best Weight Per Workout"
            guard let absDict = categoriesDictionary[10],
                let absWorkoutExercises = absDict["workoutExercises"] as? [Int: [String: Any]],
                let armDict = categoriesDictionary[8],
                let armWorkoutExercises = armDict["workoutExercises"] as? [Int: [String: Any]],
                let backDict = categoriesDictionary[12],
                let backWorkoutExercises = backDict["workoutExercises"] as? [Int: [String: Any]],
                let calvesDict = categoriesDictionary[14],
                let calvesWorkoutExercises = calvesDict["workoutExercises"] as? [Int: [String: Any]],
                let chestDict = categoriesDictionary[11],
                let chestWorkoutExercises = chestDict["workoutExercises"] as? [Int: [String: Any]],
                let legsDict = categoriesDictionary[9],
                let legsWorkoutExercises = legsDict["workoutExercises"] as? [Int: [String: Any]],
                let shouldersDict = categoriesDictionary[13],
                let shouldersWorkoutExercises = shouldersDict["workoutExercises"] as? [Int: [String: Any]] else { return }
            
            var workoutExercises = [[Int: [String: Any]]]()
            absWorkoutExercises.forEach { (k,v) in workoutExercises.append([k: v]) }
            armWorkoutExercises.forEach { (k,v) in workoutExercises.append([k: v]) }
            backWorkoutExercises.forEach { (k,v) in workoutExercises.append([k: v]) }
            calvesWorkoutExercises.forEach { (k,v) in workoutExercises.append([k: v]) }
            chestWorkoutExercises.forEach { (k,v) in workoutExercises.append([k: v]) }
            legsWorkoutExercises.forEach { (k,v) in workoutExercises.append([k: v]) }
            shouldersWorkoutExercises.forEach { (k,v) in workoutExercises.append([k: v]) }
            
            var workoutExercisesNames = [String]()
            for workoutExercise in workoutExercises {
                for value in workoutExercise.values {
                    if let name = value["name"] as? String {
                        workoutExercisesNames.append(name)
                    }
                }
            }

            drop.placeholder = "Exercises"
            drop.options = workoutExercisesNames
            drop.hideOptionsWhenSelect = true
            drop.didSelect { (option, index) in
                self.changeExerciseOption(workoutExerciseDict: workoutExercises[index])
            }
            drop.textColor = .white
            drop.borderColor = .white
            drop.tint = .white
            drop.optionsTextColor = .black
            let _ = drop.resign()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: 300.0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let screenSize = UIScreen.main.bounds
        flowLayout.itemSize = CGSize(width: screenSize.width, height: 300.0)
        
        flowLayout.invalidateLayout()
    }
    
}


