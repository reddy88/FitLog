//
//  ExerciseAddSetCollectionViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/29/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class ExerciseAddSetCollectionViewCell: UICollectionViewCell {
    
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
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName : UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        ]
        setWeightTextField.attributedPlaceholder = NSAttributedString(string: "lbs", attributes:attributes)
        setWeightTextField.tintColor = UIColor.clear
        
        setWeightTextField.text = exerciseSet.weight != nil ? "\(exerciseSet.weight ?? 0)" : ""
        setRepsTextField.text = exerciseSet.reps != nil ? "\(exerciseSet.reps ?? 0)" : ""
        
        setWeightTextField.delegate = self
        setRepsTextField.delegate = self
    }
    
}

extension ExerciseAddSetCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == setWeightTextField {
            guard let text = setWeightTextField.text, !text.isEmpty, let weight = Int(text) else { return }
            exerciseSet?.weight = weight
        } else if textField == setRepsTextField {
            guard let text = setRepsTextField.text, !text.isEmpty, let reps = Int(text) else { return }
            exerciseSet?.reps = reps
        }
    }
}
