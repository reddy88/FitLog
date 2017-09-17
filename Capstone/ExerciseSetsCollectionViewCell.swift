//
//  ExerciseSetsCollectionViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/5/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class ExerciseSetsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var setWeightLabel: UILabel!
    @IBOutlet weak var setRepsLabel: UILabel!
    
    // MARK: - Methods
    
    func updateViews(set: ExerciseSetActual) {
        setWeightLabel.text = "\(set.weight) " + SettingsController.shared.weightUnit.rawValue
        setRepsLabel.text = "\(set.reps)"
    }
    
}
