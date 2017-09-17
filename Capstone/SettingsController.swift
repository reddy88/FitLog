//
//  SettingsController.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/15/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class SettingsController {
    
    // MARK: - Class Properties
    
    static let shared = SettingsController()
    
    // MARK: - Instance Properties
    
    var weightUnit: WeightUnit = .lb
    
}

enum WeightUnit: String {
    case lb
    case kg
}
