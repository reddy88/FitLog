//
//  ColorTagTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/28/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class ColorTagTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var noTagButton: UIButton!
    @IBOutlet weak var redTagButton: UIButton!
    @IBOutlet weak var orangeTagButton: UIButton!
    @IBOutlet weak var greenTagButton: UIButton!
    @IBOutlet weak var lightBlueTagButton: UIButton!
    @IBOutlet weak var blueTagButton: UIButton!
    @IBOutlet weak var purpleTagButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func noTagButtonTapped(_ sender: UIButton) {
        //noTagButton.setBackgroundImage(#imageLiteral(resourceName: "white_border"), for: .selected)
        toggleButtonSelectedFor(button: sender)
    }
    
    @IBAction func redTagButtonTapped(_ sender: UIButton) {
        //redTagButton.setBackgroundImage(#imageLiteral(resourceName: "red_border"), for: .selected)
        toggleButtonSelectedFor(button: sender)
    }
    
    @IBAction func orangeTagButtonTapped(_ sender: UIButton) {
        //orangeTagButton.setBackgroundImage(#imageLiteral(resourceName: "orange_border"), for: .selected)
        toggleButtonSelectedFor(button: sender)
    }
    
    @IBAction func greenTagButtonTapped(_ sender: UIButton) {
        //greenTagButton.setBackgroundImage(#imageLiteral(resourceName: "green_border"), for: .selected)
        toggleButtonSelectedFor(button: sender)
    }
    
    @IBAction func lightBlueTagButtonTapped(_ sender: UIButton) {
        //lightBlueTagButton.setBackgroundImage(#imageLiteral(resourceName: "lightBlue_border"), for: .selected)
        toggleButtonSelectedFor(button: sender)
    }
    
    @IBAction func blueTagButtonTapped(_ sender: UIButton) {
        //blueTagButton.setBackgroundImage(#imageLiteral(resourceName: "blue_border"), for: .selected)
        toggleButtonSelectedFor(button: sender)
    }
    
    @IBAction func purpleTagButtonTapped(_ sender: UIButton) {
        //purpleTagButton.setBackgroundImage(#imageLiteral(resourceName: "purple_border"), for: .selected)
        toggleButtonSelectedFor(button: sender)
    }
    
    // MARK: - Methods
    
    func updateViews() {
        noTagButton.setBackgroundImage(#imageLiteral(resourceName: "white_border"), for: .selected)
        redTagButton.setBackgroundImage(#imageLiteral(resourceName: "red_border"), for: .selected)
        orangeTagButton.setBackgroundImage(#imageLiteral(resourceName: "orange_border"), for: .selected)
        greenTagButton.setBackgroundImage(#imageLiteral(resourceName: "green_border"), for: .selected)
        lightBlueTagButton.setBackgroundImage(#imageLiteral(resourceName: "lightBlue_border"), for: .selected)
        blueTagButton.setBackgroundImage(#imageLiteral(resourceName: "blue_border"), for: .selected)
        purpleTagButton.setBackgroundImage(#imageLiteral(resourceName: "purple_border"), for: .selected)
    }
    
    func toggleButtonSelectedFor(button: UIButton) {
        switch button {
        case noTagButton:
            noTagButton.isSelected = !noTagButton.isSelected
            redTagButton.isSelected = false
            orangeTagButton.isSelected = false
            greenTagButton.isSelected = false
            lightBlueTagButton.isSelected = false
            blueTagButton.isSelected = false
            purpleTagButton.isSelected = false
        case redTagButton:
            noTagButton.isSelected = false
            redTagButton.isSelected = !redTagButton.isSelected
            orangeTagButton.isSelected = false
            greenTagButton.isSelected = false
            lightBlueTagButton.isSelected = false
            blueTagButton.isSelected = false
            purpleTagButton.isSelected = false
        case orangeTagButton:
            noTagButton.isSelected = false
            redTagButton.isSelected = false
            orangeTagButton.isSelected = !orangeTagButton.isSelected
            greenTagButton.isSelected = false
            lightBlueTagButton.isSelected = false
            blueTagButton.isSelected = false
            purpleTagButton.isSelected = false
        case greenTagButton:
            noTagButton.isSelected = false
            redTagButton.isSelected = false
            orangeTagButton.isSelected = false
            greenTagButton.isSelected = !greenTagButton.isSelected
            lightBlueTagButton.isSelected = false
            blueTagButton.isSelected = false
            purpleTagButton.isSelected = false
        case lightBlueTagButton:
            noTagButton.isSelected = false
            redTagButton.isSelected = false
            orangeTagButton.isSelected = false
            greenTagButton.isSelected = false
            lightBlueTagButton.isSelected = !lightBlueTagButton.isSelected
            blueTagButton.isSelected = false
            purpleTagButton.isSelected = false
        case blueTagButton:
            noTagButton.isSelected = false
            redTagButton.isSelected = false
            orangeTagButton.isSelected = false
            greenTagButton.isSelected = false
            lightBlueTagButton.isSelected = false
            blueTagButton.isSelected = !blueTagButton.isSelected
            purpleTagButton.isSelected = false
        case purpleTagButton:
            noTagButton.isSelected = false
            redTagButton.isSelected = false
            orangeTagButton.isSelected = false
            greenTagButton.isSelected = false
            lightBlueTagButton.isSelected = false
            blueTagButton.isSelected = false
            purpleTagButton.isSelected = !purpleTagButton.isSelected
        default:
            break
        }
    }
    
    func colorTagSelected() -> TagColor {
        if redTagButton.isSelected {
            return .red
        } else if orangeTagButton.isSelected {
            return .orange
        } else if greenTagButton.isSelected {
            return .green
        } else if lightBlueTagButton.isSelected {
            return .lightBlue
        } else if blueTagButton.isSelected {
            return .blue
        } else if purpleTagButton.isSelected {
            return .purple
        }
        return .noTag
    }
    
    func setColorTag(colorTag: TagColor) {
        switch colorTag {
        case .noTag:
            noTagButton.isSelected = true
        case .red:
            redTagButton.isSelected = true
        case .orange:
            orangeTagButton.isSelected = true
        case .green:
            greenTagButton.isSelected = true
        case .lightBlue:
            lightBlueTagButton.isSelected = true
        case .blue:
            blueTagButton.isSelected = true
        case .purple:
            purpleTagButton.isSelected = true
        }
    }
    
}
