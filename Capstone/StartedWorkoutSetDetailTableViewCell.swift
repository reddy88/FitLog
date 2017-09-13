//
//  StartedWorkoutSetDetailTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/4/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class StartedWorkoutSetDetailTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var plusMinusImageView: UIImageView!
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var setCompleteButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func setCompleteButtonTapped(_ sender: UIButton) {
        guard let weightText = weightTextField.text, !weightText.isEmpty,
            let weight = Int(weightText) else { return }
        exerciseSet?.weight = Int16(weight)
        
        guard let repsText = repsTextField.text, !repsText.isEmpty,
            let reps = Int(repsText) else { return }
        exerciseSet?.reps = Int16(reps)
        
        delegate?.setCompleteButtonTapped(cell: self)
    }
    
    // MARK: Properties
    
    weak var delegate: StartedWorkoutSetDetailTableViewCellDelegate?
    
    var exerciseSet: ExerciseSet? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: Methods
    
    func updateViews() {
        guard let exerciseSet = exerciseSet else { return }
        setCompleteButton.setImage(#imageLiteral(resourceName: "set_complete_checkmark"), for: .selected)
        if exerciseSet.isCompleted {
            setCompleteButton.isSelected = true
            plusMinusImageView.image = #imageLiteral(resourceName: "set_plus")
        } else {
            setCompleteButton.isSelected = false
            plusMinusImageView.image = #imageLiteral(resourceName: "set_minus")
        }
        weightTextField.placeholder = "\(exerciseSet.weight)"
        weightTextField.text = "\(exerciseSet.weight)"
        repsTextField.placeholder = "\(exerciseSet.reps)"
        repsTextField.text = "\(exerciseSet.reps)"
        
        weightTextField.delegate = self
        repsTextField.delegate = self
    }
    
}

// MARK: - UITextFieldDelegate

extension StartedWorkoutSetDetailTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == weightTextField {
            guard let text = weightTextField.text, !text.isEmpty,
                let weight = Int(text) else { return }
            exerciseSet?.weight = Int16(weight)
        }
        if textField == repsTextField {
            guard let text = repsTextField.text, !text.isEmpty,
                let reps = Int(text) else { return }
            exerciseSet?.reps = Int16(reps)
        }
    }
    
}

// MARK: - StartedWorkoutSetDetailTableViewCellDelegate

protocol StartedWorkoutSetDetailTableViewCellDelegate: class {
    func setCompleteButtonTapped(cell: StartedWorkoutSetDetailTableViewCell)
}
