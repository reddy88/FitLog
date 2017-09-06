//
//  WorkoutTitleWithDateTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/5/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutTitleWithDateTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var colorTagImageView: UIImageView!
    
    
    // MARK: - Methods
    
    func updateViews(workout: Workout, dateAsString: String) {
        dateLabel.text = dateAsString
        workoutNameLabel.text = workout.name?.uppercased()
        if workout.tagColor != .noTag {
            colorTagImageView.image = UIImage(named: "\(workout.tagColor.rawValue)")
        }
    }

}
