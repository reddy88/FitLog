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
    @IBOutlet weak var setBackgroundView: UIView!
    @IBOutlet weak var setCrossImageView: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightUnitLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var repsUnitLabel: UILabel!
    @IBOutlet weak var weightUnitLabelForTextField: UILabel!
    
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
    
    var exerciseSet: ExerciseSetActual? {
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
            setBackgroundView.backgroundColor = UIColor(red: 56.0/255.0, green: 176.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            setCrossImageView.alpha = 1
            setNumberLabel.alpha = 0
            repsLabel.alpha = 1
            repsLabel.text = "\(exerciseSet.reps)"
            repsUnitLabel.alpha = 1
            weightLabel.alpha = 1
            weightLabel.text = "\(exerciseSet.weight)"
            weightUnitLabel.alpha = 1
            weightUnitLabel.text = SettingsController.shared.weightUnit.rawValue
        } else {
            setCompleteButton.isSelected = false
            plusMinusImageView.image = #imageLiteral(resourceName: "set_minus")
            setBackgroundView.backgroundColor = UIColor(red: 72.0/255.0, green: 62.0/255.0, blue: 104.0/255.0, alpha: 1.0)
            setCrossImageView.alpha = 0
            setNumberLabel.alpha = 1
            repsLabel.alpha = 0
            repsLabel.text = ""
            repsUnitLabel.alpha = 0
            weightLabel.alpha = 0
            weightLabel.text = ""
            weightUnitLabel.alpha = 0
        }
        weightTextField.placeholder = "\(exerciseSet.weight)"
        weightTextField.text = "\(exerciseSet.weight)"
        repsTextField.placeholder = "\(exerciseSet.reps)"
        repsTextField.text = "\(exerciseSet.reps)"
        
        weightUnitLabelForTextField.text = SettingsController.shared.weightUnit.rawValue
        
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
