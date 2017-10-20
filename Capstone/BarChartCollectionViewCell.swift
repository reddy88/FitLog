//
//  BarChartCollectionViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/12/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit
import Charts

class BarChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    
    func updateViews(statsDictionary: [Int: [String: Any]]?) {
        barChartView.noDataText = "No workout data available"
        barChartView.noDataTextColor = .white
        guard let statsDictionary = statsDictionary else { return }
        
        var entries = [BarChartDataEntry]()

        for value in statsDictionary.values {
            if let sets = value["sets"] as? [Int] {
                for (index, set) in sets.enumerated() {
                    entries.append(BarChartDataEntry(x: Double(index + 1), y: Double(set)))
                }
            }
        }
        
        let bars = BarChartDataSet(values: entries, label: "Workouts")
        bars.valueColors = [NSUIColor.white]
        bars.highlightEnabled = false
        
        let data = BarChartData()
        data.addDataSet(bars)
        
        barChartView.noDataTextColor = .white
        barChartView.noDataText = "Select Exercise"
        barChartView.data = data
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelTextColor = .white
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.legend.enabled = true
        barChartView.legend.textColor = .white
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.labelTextColor = .white
        barChartView.highlightFullBarEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
        barChartView.leftAxis.granularityEnabled = true
        barChartView.leftAxis.granularity = 1.0
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
    }
}
