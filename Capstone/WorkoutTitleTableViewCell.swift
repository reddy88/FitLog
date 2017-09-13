//
//  WorkoutTitleTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/3/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutTitleTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var colorTagImageView: UIImageView!
    
    // MARK: - Methods
    
    func updateViews(workout: Workout) {
        workoutNameLabel.text = workout.name?.uppercased()
        if workout.tagColor != TagColor.noTag.rawValue {
            if let tagColor = workout.tagColor {
                colorTagImageView.image = UIImage(named: tagColor)
            }
        }
    }

}
