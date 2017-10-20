//
//  LogViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/9/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
 
    var workoutsCompletedReversed = Array(WorkoutCompletedController.shared.workoutsCompleted.reversed())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWorkoutCompletedDetail" {
            let workoutCompletedVC = segue.destination as? WorkoutCompletedViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            workoutCompletedVC?.workoutCompleted = workoutsCompletedReversed[indexPath.row]
        }
    }
 

}

extension LogViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsCompletedReversed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as? LogTableViewCell else { return LogTableViewCell() }
        cell.updateViewsWith(workoutsCompletedReversed[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
