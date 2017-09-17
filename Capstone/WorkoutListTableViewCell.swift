//
//  WorkoutListTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/14/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutListTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutTagColorImageView: UIImageView!
    
    // MARK: - Methods
    
    func updateWith(workout: Workout) {
        workoutNameLabel.text = workout.name
        if let tagColor = workout.tagColor {
            workoutTagColorImageView.image = UIImage(named: tagColor)
        }
    }
}
