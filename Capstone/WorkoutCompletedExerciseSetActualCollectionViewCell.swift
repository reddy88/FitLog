//
//  WorkoutCompletedExerciseSetActualCollectionViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/9/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutCompletedExerciseSetActualCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    func updateViewsWith(exerciseSetActual: ExerciseSetActual, setNumber: Int) {
        setNumberLabel.text = "\(setNumber)"
        weightLabel.text = "\(exerciseSetActual.weight)"
        repsLabel.text = "\(exerciseSetActual.reps)"
    }
    
    
}
