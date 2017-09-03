//
//  ExerciseController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/26/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class ExerciseController {
    
    // MARK: - Class Properties
    
    static let shared = ExerciseController()
    
    // MARK: - Instance Properties
    
    var exercises: [Exercise] = []
    var exercisesToDisplay: [Exercise] = []
    var exercisesSelected: [Exercise] = []
    
    var exercisesArms: [Exercise] = []
    var exercisesLegs: [Exercise] = []
    var exercisesAbs: [Exercise] = []
    var exercisesChest: [Exercise] = []
    var exercisesBack: [Exercise] = []
    var exercisesShoulders: [Exercise] = []
    var exercisesCalves: [Exercise] = []
    
//    var exerciseCategories: [Int: String] = [:]
    
    
    let baseURL = "https://wger.de/api/v2/"
    
    // MARK: - Methods
    
    func getExercises(completion:  (() -> Void)? = nil) {
        guard let baseURL = URL(string: baseURL)?.appendingPathComponent("exercise") else { completion?(); return }
        
        let statusQueryItem = URLQueryItem(name: "status", value: "2")
        let languageQueryItem = URLQueryItem(name: "language", value: "2")
        let limitQueryItem = URLQueryItem(name: "limit", value: "250")
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [statusQueryItem, languageQueryItem, limitQueryItem]
        
        guard let endpointURL = components?.url else { completion?(); return }
        
        let dataTask = URLSession.shared.dataTask(with: endpointURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion?()
                return
            }
            
            guard let data = data,
                let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                let resultsArray = jsonDictionary["results"] as? [[String: Any]] else { completion?(); return }
            
            let exercises = resultsArray.flatMap { Exercise(dictionary: $0) }
            
            self.exercises = exercises
            self.setCategoryForExercises()
            self.exercisesToDisplay = self.exercisesArms
            completion?()
        }
        dataTask.resume()
    }
    
//    func getExerciseCategories(completion: (() -> Void)? = nil) {
//        guard let endpointURL = URL(string: baseURL)?.appendingPathComponent("exercisecategory") else { completion?(); return }
//        
//        let dataTask = URLSession.shared.dataTask(with: endpointURL) { (data, _, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion?()
//                return
//            }
//            
//            guard let data = data,
//                let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
//                let resultsArray = jsonDictionary["results"] as? [[String: Any]] else { completion?(); return }
//            
//            var exerciseCategories: [Int: String] = [:]
//            for exerciseDictionary in resultsArray {
//                guard let key = exerciseDictionary["id"] as? Int,
//                    let value = exerciseDictionary["name"] as? String else { completion?(); return }
//                
//                exerciseCategories[key] = value
//            }
//            
//            self.exerciseCategories = exerciseCategories
//            completion?()
//        }
//        dataTask.resume()
//    }
    
    func setCategoryForExercises() {
        for exercise in exercises {
            switch exercise.category {
            case 10:
                exercisesAbs.append(exercise)
            case 8:
                exercisesArms.append(exercise)
            case 12:
                exercisesBack.append(exercise)
            case 14:
                exercisesCalves.append(exercise)
            case 11:
                exercisesChest.append(exercise)
            case 9:
                exercisesLegs.append(exercise)
            case 13:
                exercisesShoulders.append(exercise)
            default:
                 break
            }
        }
    }
    
    func changeExerciseCatetoryTo(selectedSegmentIndex: Int) {
        switch selectedSegmentIndex {
        case 0:
            exercisesToDisplay = exercisesArms
        case 1:
            exercisesToDisplay = exercisesLegs
        case 2:
            exercisesToDisplay = exercisesAbs
        case 3:
            exercisesToDisplay = exercisesChest
        case 4:
            exercisesToDisplay = exercisesBack
        case 5:
            exercisesToDisplay = exercisesShoulders
        case 6:
            exercisesToDisplay = exercisesCalves
        default:
            break
        }
    }
}
