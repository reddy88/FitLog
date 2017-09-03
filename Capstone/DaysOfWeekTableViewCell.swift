//
//  DaysOfWeekTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/28/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class DaysOfWeekTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func dayButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // MARK: - Methods
    
    func updateViews() {
        sundayButton.setBackgroundImage(#imageLiteral(resourceName: "day_border"), for: .selected)
        mondayButton.setBackgroundImage(#imageLiteral(resourceName: "day_border"), for: .selected)
        tuesdayButton.setBackgroundImage(#imageLiteral(resourceName: "day_border"), for: .selected)
        wednesdayButton.setBackgroundImage(#imageLiteral(resourceName: "day_border"), for: .selected)
        thursdayButton.setBackgroundImage(#imageLiteral(resourceName: "day_border"), for: .selected)
        fridayButton.setBackgroundImage(#imageLiteral(resourceName: "day_border"), for: .selected)
        saturdayButton.setBackgroundImage(#imageLiteral(resourceName: "day_border"), for: .selected)
    }
    
    func daysSelected() -> [DayOfWeek]{
        var daysSelected: [DayOfWeek] = []
        
        if sundayButton.isSelected {
            daysSelected.append(.sunday)
        }
        if mondayButton.isSelected {
            daysSelected.append(.monday)
        }
        if tuesdayButton.isSelected {
            daysSelected.append(.tuesday)
        }
        if wednesdayButton.isSelected {
            daysSelected.append(.wednesday)
        }
        if thursdayButton.isSelected {
            daysSelected.append(.thursday)
        }
        if fridayButton.isSelected {
            daysSelected.append(.friday)
        }
        if saturdayButton.isSelected {
            daysSelected.append(.saturday)
        }
        
        return daysSelected
    }
    
    func setDaysSelected(daysSelected: [DayOfWeek]) {
        for day in daysSelected {
            switch day {
            case .sunday:
                sundayButton.isSelected = true
            case .monday:
                mondayButton.isSelected = true
            case .tuesday:
                tuesdayButton.isSelected = true
            case .wednesday:
                wednesdayButton.isSelected = true
            case .thursday:
                thursdayButton.isSelected = true
            case .friday:
                fridayButton.isSelected = true
            case .saturday:
                saturdayButton.isSelected = true
            }
        }
    }

}
