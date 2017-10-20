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
    @IBOutlet weak var workoutTimeLabel: UILabel!
    
    
    // MARK: - Methods
    
    func updateViews(workout: ActualWorkout, dateAsString: String, time: Double) {
        dateLabel.text = dateAsString
        workoutTimeLabel.text = "\(Int(time / 60)) mins"
        workoutNameLabel.text = workout.name?.uppercased()
        if workout.tagColor != TagColor.noTag.rawValue {
            if let tagColor = workout.tagColor {
                colorTagImageView.image = UIImage(named: tagColor)
            }
        }
    }

}
