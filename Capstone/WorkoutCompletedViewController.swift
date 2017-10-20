//
//  WorkoutCompletedViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/9/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutCompletedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    var workoutCompleted: WorkoutCompleted?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EMMMd")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        guard let workoutCompleted = workoutCompleted,
            let date = workoutCompleted.date,
            let tagColor = workoutCompleted.actualWorkout?.tagColor else { return }
        
        
        let titleLabel = UILabel()
        titleLabel.text = workoutCompleted.actualWorkout?.name
        titleLabel.sizeToFit()
        titleLabel.textColor = .white
        
        let tagColorImageView = UIImageView(image: UIImage(named: tagColor))
        tagColorImageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleView.addSubview(tagColorImageView)
        
        let views: [String: Any] = ["titleLabel": titleLabel, "tagColorImageView": tagColorImageView]
        let titleViewHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|[titleLabel]-(5)-[tagColorImageView(15)]|", options: [], metrics: nil, views: views)
        let titleLabelVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel(20)]|", options: [], metrics: nil, views: views)
        let tagColorImageViewVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[tagColorImageView(15)]-2-|", options: [], metrics: nil, views: views)
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tagColorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addConstraints(titleViewHorizontalConstraint)
        titleView.addConstraints(titleLabelVerticalConstraint)
        titleView.addConstraints(tagColorImageViewVerticalConstraint)
        
        navigationItem.titleView = titleView
        
        dateLabel.text = dateFormatter.string(from: date as Date)
        minutesLabel.text = "Time: \(Int(workoutCompleted.time / 60)) mins"
    }

}

extension WorkoutCompletedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutCompleted?.actualWorkout?.exercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutExerciseCell", for: indexPath) as? WorkoutCompletedExerciseTableViewCell,
            let workoutExercise = workoutCompleted?.actualWorkout?.exercises?[indexPath.row] as? WorkoutExerciseActual else { return WorkoutCompletedExerciseTableViewCell() }
        cell.exerciseNameLabel.text = workoutExercise.name
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        return cell
    }
    
}

extension WorkoutCompletedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let workoutExercises = workoutCompleted?.actualWorkout?.exercises?.array as? [WorkoutExerciseActual]
        return workoutExercises?[collectionView.tag].sets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseSetCell", for: indexPath) as? WorkoutCompletedExerciseSetActualCollectionViewCell,
        let workoutExercises = workoutCompleted?.actualWorkout?.exercises?.array as? [WorkoutExerciseActual],
        let exerciseSetsActual = workoutExercises[collectionView.tag].sets?.array as? [ExerciseSetActual] else { return WorkoutCompletedExerciseSetActualCollectionViewCell() }
        cell.updateViewsWith(exerciseSetActual: exerciseSetsActual[indexPath.item], setNumber: indexPath.item + 1)
        return cell
    }
    
}
