//
//  WorkoutCompletedExerciseTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/9/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutCompletedExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
}
