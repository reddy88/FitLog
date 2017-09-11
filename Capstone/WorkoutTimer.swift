//
//  WorkoutTimer.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/5/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import Foundation

class WorkoutTimer {
    
    // MARK: - Class Properties
    
    static let shared = WorkoutTimer()
    static let workoutTimerFired = Notification.Name(rawValue:"workoutTimerFired")
    
    // MARK: - Instance Properties
    
    var timer: Timer
    
    // MARK: - Initializers
    
    init() {
        timer = Timer()
    }
    
    // MARK: - Methods
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        timer.tolerance = 0.5
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func timerFired() {
        NotificationCenter.default.post(name: WorkoutTimer.workoutTimerFired, object: nil)
    }
    
}
