//
//  LogTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/9/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var workoutColorTagImageView: UIImageView!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EMMMd")
        return formatter
    }()
    
    func updateViewsWith(_ workout: WorkoutCompleted) {
        guard let date = workout.date,
            let tagColor = workout.actualWorkout?.tagColor else { return }
        workoutNameLabel.text = workout.actualWorkout?.name
        dateLabel.text = dateFormatter.string(from: date as Date)
        workoutColorTagImageView.image = UIImage(named: tagColor)
    }
    

}
