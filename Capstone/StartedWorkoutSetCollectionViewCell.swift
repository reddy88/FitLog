//
//  StartedWorkoutSetCollectionViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/3/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class StartedWorkoutSetCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var setWeightTextField: UITextField!
    @IBOutlet weak var setRepsTextField: UITextField!
    
    // MARK: - Properties
    
    var exerciseSet: ExerciseSet?
    var exerciseSetNumber: Int? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard let exerciseSet = exerciseSet, let exerciseSetNumber = exerciseSetNumber else { return }
        setNumberLabel.text = "\(exerciseSetNumber)"
        setWeightTextField.text = exerciseSet.weight != nil ? "\(exerciseSet.weight ?? 0)" : ""
        setRepsTextField.text = exerciseSet.reps != nil ? "\(exerciseSet.reps ?? 0)" : ""
    }
    
}
