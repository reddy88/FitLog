//
//  ChartsExercisesListViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/11/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class ChartsExercisesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func exerciseCategoryCustomSegmentedControlValueChanged(_ sender: CustomSegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            displayExercisesCompleted = armExercisesCompleted
        case 1:
            displayExercisesCompleted = legsExercisesCompleted
        case 2:
            displayExercisesCompleted = absExercisesCompleted
        case 3:
            displayExercisesCompleted = chestExercisesCompleted
        case 4:
            displayExercisesCompleted = backExercisesCompleted
        case 5:
            displayExercisesCompleted = shouldersExercisesCompleted
        case 6:
            displayExercisesCompleted = calvesExercisesCompleted
        default:
            break
        }
        tableView.reloadData()
    }
    
    var categoriesDictionary = [10: ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]]

    var displayExercisesCompleted = [WorkoutExerciseActual]()
    var armExercisesCompleted = [WorkoutExerciseActual]()
    var armExerciseSCount = 0
    var legsExercisesCompleted = [WorkoutExerciseActual]()
    var legsExerciseSCount = 0
    var absExercisesCompleted = [WorkoutExerciseActual]()
    var absExerciseSCount = 0
    var chestExercisesCompleted = [WorkoutExerciseActual]()
    var chestExerciseSCount = 0
    var backExercisesCompleted = [WorkoutExerciseActual]()
    var backExerciseSCount = 0
    var shouldersExercisesCompleted = [WorkoutExerciseActual]()
    var shouldersExerciseSCount = 0
    var calvesExercisesCompleted = [WorkoutExerciseActual]()
    var calvesExerciseSCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        categoriesDictionary[8] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[12] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[14] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[11] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[9] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        categoriesDictionary[13] = ["totalCount": 0, "numberOfSets": 0, "workoutExercises": [Int: [String: Any]]()]
        
        title = "Exercises"
        
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
                        var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseNumberOfSets = actualWorkoutExerciseDict["numberOfSets"] as? Int else { return }
                    
                    totalCount += 1
                    categoriesDictionary[10]?["totalCount"] = totalCount
                    numberOfSets += actualWorkoutExerciseSetsCount
                    categoriesDictionary[10]?["numberOfSets"] = numberOfSets
                    
                    actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                    actualWorkoutExerciseNumberOfSets += actualWorkoutExerciseSetsCount
                    actualWorkoutExerciseDict["numberOfSets"] = actualWorkoutExerciseNumberOfSets
                    workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                    categoriesDictionary[10]?["workoutExercises"] = workoutExercises
                case 8:
                    guard let armDict = categoriesDictionary[8],
                        var totalCount = armDict["totalCount"] as? Int,
                        var numberOfSets = armDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = armDict["workoutExercises"] as? [Int: [String: Any]],
                        var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseNumberOfSets = actualWorkoutExerciseDict["numberOfSets"] as? Int else { return }
                    
                    totalCount += 1
                    categoriesDictionary[8]?["totalCount"] = totalCount
                    numberOfSets += actualWorkoutExerciseSetsCount
                    categoriesDictionary[8]?["numberOfSets"] = numberOfSets
                    
                    actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                    actualWorkoutExerciseNumberOfSets += actualWorkoutExerciseSetsCount
                    actualWorkoutExerciseDict["numberOfSets"] = actualWorkoutExerciseNumberOfSets
                    workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                    categoriesDictionary[8]?["workoutExercises"] = workoutExercises
                case 12:
                    guard let backDict = categoriesDictionary[12],
                        var totalCount = backDict["totalCount"] as? Int,
                        var numberOfSets = backDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = backDict["workoutExercises"] as? [Int: [String: Any]],
                        var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseNumberOfSets = actualWorkoutExerciseDict["numberOfSets"] as? Int else { return }
                    
                    totalCount += 1
                    categoriesDictionary[12]?["totalCount"] = totalCount
                    numberOfSets += actualWorkoutExerciseSetsCount
                    categoriesDictionary[12]?["numberOfSets"] = numberOfSets
                    
                    actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                    actualWorkoutExerciseNumberOfSets += actualWorkoutExerciseSetsCount
                    actualWorkoutExerciseDict["numberOfSets"] = actualWorkoutExerciseNumberOfSets
                    workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                    categoriesDictionary[12]?["workoutExercises"] = workoutExercises
                case 14:
                    guard let calvesDict = categoriesDictionary[14],
                        var totalCount = calvesDict["totalCount"] as? Int,
                        var numberOfSets = calvesDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = calvesDict["workoutExercises"] as? [Int: [String: Any]],
                        var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseNumberOfSets = actualWorkoutExerciseDict["numberOfSets"] as? Int else { return }
                    
                    totalCount += 1
                    categoriesDictionary[14]?["totalCount"] = totalCount
                    numberOfSets += actualWorkoutExerciseSetsCount
                    categoriesDictionary[14]?["numberOfSets"] = numberOfSets
                    
                    actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                    actualWorkoutExerciseNumberOfSets += actualWorkoutExerciseSetsCount
                    actualWorkoutExerciseDict["numberOfSets"] = actualWorkoutExerciseNumberOfSets
                    workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                    categoriesDictionary[14]?["workoutExercises"] = workoutExercises
                case 11:
                    guard let chestDict = categoriesDictionary[11],
                        var totalCount = chestDict["totalCount"] as? Int,
                        var numberOfSets = chestDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = chestDict["workoutExercises"] as? [Int: [String: Any]],
                        var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseNumberOfSets = actualWorkoutExerciseDict["numberOfSets"] as? Int else { return }
                    
                    totalCount += 1
                    categoriesDictionary[11]?["totalCount"] = totalCount
                    numberOfSets += actualWorkoutExerciseSetsCount
                    categoriesDictionary[11]?["numberOfSets"] = numberOfSets
                    
                    actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                    actualWorkoutExerciseNumberOfSets += actualWorkoutExerciseSetsCount
                    actualWorkoutExerciseDict["numberOfSets"] = actualWorkoutExerciseNumberOfSets
                    workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                    categoriesDictionary[11]?["workoutExercises"] = workoutExercises
                case 9:
                    guard let legsDict = categoriesDictionary[9],
                        var totalCount = legsDict["totalCount"] as? Int,
                        var numberOfSets = legsDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = legsDict["workoutExercises"] as? [Int: [String: Any]],
                        var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseNumberOfSets = actualWorkoutExerciseDict["numberOfSets"] as? Int else { return }
                    
                    totalCount += 1
                    categoriesDictionary[9]?["totalCount"] = totalCount
                    numberOfSets += actualWorkoutExerciseSetsCount
                    categoriesDictionary[9]?["numberOfSets"] = numberOfSets
                    
                    actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                    actualWorkoutExerciseNumberOfSets += actualWorkoutExerciseSetsCount
                    actualWorkoutExerciseDict["numberOfSets"] = actualWorkoutExerciseNumberOfSets
                    workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                    categoriesDictionary[9]?["workoutExercises"] = workoutExercises
                case 13:
                    guard let shouldersDict = categoriesDictionary[13],
                        var totalCount = shouldersDict["totalCount"] as? Int,
                        var numberOfSets = shouldersDict["numberOfSets"] as? Int,
                        let actualWorkoutExerciseSetsCount = actualWorkoutExercise.sets?.count,
                        var workoutExercises = shouldersDict["workoutExercises"] as? [Int: [String: Any]],
                        var actualWorkoutExerciseDict = workoutExercises[Int(actualWorkoutExercise.id)],
                        var actualWorkoutExerciseNumberOfSets = actualWorkoutExerciseDict["numberOfSets"] as? Int else { return }
                    
                    totalCount += 1
                    categoriesDictionary[13]?["totalCount"] = totalCount
                    numberOfSets += actualWorkoutExerciseSetsCount
                    categoriesDictionary[13]?["numberOfSets"] = numberOfSets
                    
                    actualWorkoutExerciseDict["name"] = actualWorkoutExercise.name
                    actualWorkoutExerciseNumberOfSets += actualWorkoutExerciseSetsCount
                    actualWorkoutExerciseDict["numberOfSets"] = actualWorkoutExerciseNumberOfSets
                    workoutExercises[Int(actualWorkoutExercise.id)] = actualWorkoutExerciseDict
                    categoriesDictionary[13]?["workoutExercises"] = workoutExercises
                default:
                    break
                }
            }
        }
        
        displayExercisesCompleted = armExercisesCompleted
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChartsExercisesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayExercisesCompleted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chartExerciseCell", for: indexPath)
        cell.textLabel?.text = displayExercisesCompleted[indexPath.row].name
        return cell
    }
    
}
