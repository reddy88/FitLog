//
//  PieChartCollectionViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/12/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit
import Charts

class PieChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    func updateViews(statsDictionary: [Int: [String: Any]], showCategoryTotalCount: Bool) {
        guard let absDict = statsDictionary[10],
            let absTotalCount = absDict["totalCount"] as? Int,
            let absNumberOfSets = absDict["numberOfSets"] as? Int,
            let armDict = statsDictionary[8],
            let armTotalCount = armDict["totalCount"] as? Int,
            let armNumberOfSets = armDict["numberOfSets"] as? Int,
            let backDict = statsDictionary[12],
            let backTotalCount = backDict["totalCount"] as? Int,
            let backNumberOfSets = backDict["numberOfSets"] as? Int,
            let calvesDict = statsDictionary[14],
            let calvesTotalCount = calvesDict["totalCount"] as? Int,
            let calvesNumberOfSets = calvesDict["numberOfSets"] as? Int,
            let chestDict = statsDictionary[11],
            let chestTotalCount = chestDict["totalCount"] as? Int,
            let chestNumberOfSets = chestDict["numberOfSets"] as? Int,
            let legsDict = statsDictionary[9],
            let legsTotalCount = legsDict["totalCount"] as? Int,
            let legsNumberOfSets = legsDict["numberOfSets"] as? Int,
            let shouldersDict = statsDictionary[13],
            let shouldersTotalCount = shouldersDict["totalCount"] as? Int,
            let shouldersNumberOfSets = shouldersDict["numberOfSets"] as? Int else { return }
        
        var entries = [PieChartDataEntry]()
        var chartLabel = ""
        if showCategoryTotalCount {
            chartLabel = "Total Count"
            if absTotalCount > 0 {
                entries.append(PieChartDataEntry(value: Double(absTotalCount), label: "Abs"))
            }
            if armTotalCount > 0 {
                entries.append(PieChartDataEntry(value: Double(armTotalCount), label: "Arms"))
            }
            if backTotalCount > 0 {
                entries.append(PieChartDataEntry(value: Double(backTotalCount), label: "Back"))
            }
            if calvesTotalCount > 0 {
                entries.append(PieChartDataEntry(value: Double(calvesTotalCount), label: "Calves"))
            }
            if chestTotalCount > 0 {
                entries.append(PieChartDataEntry(value: Double(chestTotalCount), label: "Chest"))
            }
            if legsTotalCount > 0 {
                entries.append(PieChartDataEntry(value: Double(legsTotalCount), label: "Legs"))
            }
            if shouldersTotalCount > 0 {
                entries.append(PieChartDataEntry(value: Double(shouldersTotalCount), label: "Shoulders"))
            }
        } else {
            chartLabel = "Number Of Sets"
            if absNumberOfSets > 0 {
                entries.append(PieChartDataEntry(value: Double(absNumberOfSets), label: "Abs"))
            }
            if armNumberOfSets > 0 {
                entries.append(PieChartDataEntry(value: Double(armNumberOfSets), label: "Arms"))
            }
            if backNumberOfSets > 0 {
                entries.append(PieChartDataEntry(value: Double(backNumberOfSets), label: "Back"))
            }
            if calvesNumberOfSets > 0 {
                entries.append(PieChartDataEntry(value: Double(calvesNumberOfSets), label: "Calves"))
            }
            if chestNumberOfSets > 0 {
                entries.append(PieChartDataEntry(value: Double(chestNumberOfSets), label: "Chest"))
            }
            if legsNumberOfSets > 0 {
                entries.append(PieChartDataEntry(value: Double(legsNumberOfSets), label: "Legs"))
            }
            if shouldersNumberOfSets > 0 {
                entries.append(PieChartDataEntry(value: Double(shouldersNumberOfSets), label: "Shoulders"))
            }
        }
        
        let pieChartDataSet = PieChartDataSet(values: entries, label: chartLabel)
        pieChartDataSet.colors = ChartColorTemplates.material()
        pieChartDataSet.selectionShift = 0.0
        pieChartDataSet.sliceSpace = 2.0
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        pieChartView.chartDescription?.text = ""
        pieChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        pieChartView.rotationEnabled = false
        pieChartView.holeColor = NSUIColor.white.withAlphaComponent(0.0)
        pieChartView.legend.textColor = .white
    }
    
}
