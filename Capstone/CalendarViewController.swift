//
//  CalendarViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 10/10/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var calendarLeftArrow: UIImageView!
    @IBOutlet weak var calendarRightArrow: UIImageView!
    
    let outsideMonthColor = UIColor(white: 1.0, alpha: 0.25)
    let monthColor = UIColor(white: 1.0, alpha: 0.75)
    let selectedMonthColor = UIColor(white: 1.0, alpha: 1.0)
    
    let red = UIColor(red: 208.0/255.0, green: 3.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    let orange = UIColor(red: 233.0/255.0, green: 158.0/255.0, blue: 32.0/255.0, alpha: 1.0)
    let green = UIColor(red: 126.0/255.0, green: 211.0/255.0, blue: 34.0/255.0, alpha: 1.0)
    let lightBlue = UIColor(red: 81.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    let blue = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    let purple = UIColor(red: 144.0/255.0, green: 19.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    
    let dateFormatter = DateFormatter()
    var startDate: Date?
    var endDate: Date?
    
    var actualWorkouts = [ActualWorkout]()
    var events: [[String: String]] = [[:]]
    var eventsForSelectedDay: [[String: String]] = []
    var scheduled: [[String: String]] = [[:]]
    var scheduledForSelectedDay: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsForCalendar(from: visibleDates)
        }
        
        dateFormatter.dateFormat = "yyyy MM dd"
        
        for (index, workoutCompleted) in WorkoutCompletedController.shared.workoutsCompleted.enumerated() {
            guard let date = workoutCompleted.date,
                let actualWorkout = workoutCompleted.actualWorkout,
                let name = actualWorkout.name,
                let tagColor = actualWorkout.tagColor else { return }
            
            let dateString = dateFormatter.string(from: date as Date)
            events.append([dateString: name, "name": name, "index": "\(index)" ,"tagColor": tagColor])
        }
        
        for (index, workout) in WorkoutController.shared.workouts.enumerated() {
            guard let tagColor = workout.tagColor,
                let name = workout.name else { return }
            var daysString = ""
            if workout.sunday == true {
                daysString += "1 "
            }
            if workout.monday == true {
                daysString += "2 "
            }
            if workout.tuesday == true {
                daysString += "3 "
            }
            if workout.wednesday == true {
                daysString += "4 "
            }
            if workout.thursday == true {
                daysString += "5 "
            }
            if workout.friday == true {
                daysString += "6 "
            }
            if workout.saturday == true {
                daysString += "7 "
            }
            scheduled.append([daysString: name, "name": name, "index": "\(index)", "tagColor": tagColor])
        }
        
        calendarView.reloadData()
    }
    
    func handleCellSelectedColor(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CalendarCollectionViewCell else { return }
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        dateFormatter.dateFormat = "yyyy MM dd"
        
        if dateFormatter.string(from: cellState.date) < dateFormatter.string(from: Date()) {
            processEvents(view: view, cellState: cellState)
        }
        
        if dateFormatter.string(from: cellState.date) == dateFormatter.string(from: Date()) {
            processScheduled(view: view, cellState: cellState)
            if eventsForSelectedDay.count > 0 {
                processEvents(view: view, cellState: cellState)
            }
        }
        
        if dateFormatter.string(from: cellState.date) > dateFormatter.string(from: Date()){
            processScheduled(view: view, cellState: cellState)
        }
        
    }
    
    func processEvents(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CalendarCollectionViewCell else { return }
        
        dateFormatter.dateFormat = "yyyy MM dd"
        
        for event in events {
            if cellState.isSelected {
                if event.contains(where: { $0.key == dateFormatter.string(from: cellState.date) }) {
                    guard let tagColor = event["tagColor"] else { return }
                    switch tagColor {
                    case "red":
                        cell.dateLabel.textColor = red.withAlphaComponent(1.0)
                    case "orange":
                        cell.dateLabel.textColor = orange.withAlphaComponent(1.0)
                    case "green":
                        cell.dateLabel.textColor = green.withAlphaComponent(1.0)
                    case "lightBlue":
                        cell.dateLabel.textColor = lightBlue.withAlphaComponent(1.0)
                    case "blue":
                        cell.dateLabel.textColor = blue.withAlphaComponent(1.0)
                    case "purple":
                        cell.dateLabel.textColor = purple.withAlphaComponent(1.0)
                    default:
                        break
                    }
                    return
                } else {
                    cell.dateLabel.textColor = selectedMonthColor
                }
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    if event.contains(where: { $0.key == dateFormatter.string(from: cellState.date) }) {
                        guard let tagColor = event["tagColor"] else { return }
                        switch tagColor {
                        case "red":
                            cell.dateLabel.textColor = red.withAlphaComponent(0.75)
                        case "orange":
                            cell.dateLabel.textColor = orange.withAlphaComponent(0.75)
                        case "green":
                            cell.dateLabel.textColor = green.withAlphaComponent(0.75)
                        case "lightBlue":
                            cell.dateLabel.textColor = lightBlue.withAlphaComponent(0.75)
                        case "blue":
                            cell.dateLabel.textColor = blue.withAlphaComponent(0.75)
                        case "purple":
                            cell.dateLabel.textColor = purple.withAlphaComponent(0.75)
                        default:
                            break
                        }
                        return
                    } else {
                        cell.dateLabel.textColor = monthColor
                    }
                } else {
                    if event.contains(where: { $0.key == dateFormatter.string(from: cellState.date) }) {
                        guard let tagColor = event["tagColor"] else { return }
                        switch tagColor {
                        case "red":
                            cell.dateLabel.textColor = red.withAlphaComponent(0.25)
                        case "orange":
                            cell.dateLabel.textColor = orange.withAlphaComponent(0.25)
                        case "green":
                            cell.dateLabel.textColor = green.withAlphaComponent(0.25)
                        case "lightBlue":
                            cell.dateLabel.textColor = lightBlue.withAlphaComponent(0.25)
                        case "blue":
                            cell.dateLabel.textColor = blue.withAlphaComponent(0.25)
                        case "purple":
                            cell.dateLabel.textColor = purple.withAlphaComponent(0.25)
                        default:
                            break
                        }
                        return
                    } else {
                        cell.dateLabel.textColor = outsideMonthColor
                    }
                }
            }
        }
    }
    
    func processScheduled(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CalendarCollectionViewCell else { return }
        
        dateFormatter.dateFormat = "yyyy MM dd"
        
        for workout in scheduled {
            if cellState.isSelected {
                if workout.contains(where: { $0.key.contains("\(cellState.day.rawValue)") }) {
                    guard let tagColor = workout["tagColor"] else { return }
                    switch tagColor {
                    case "red":
                        cell.dateLabel.textColor = red.withAlphaComponent(1.0)
                    case "orange":
                        cell.dateLabel.textColor = orange.withAlphaComponent(1.0)
                    case "green":
                        cell.dateLabel.textColor = green.withAlphaComponent(1.0)
                    case "lightBlue":
                        cell.dateLabel.textColor = lightBlue.withAlphaComponent(1.0)
                    case "blue":
                        cell.dateLabel.textColor = blue.withAlphaComponent(1.0)
                    case "purple":
                        cell.dateLabel.textColor = purple.withAlphaComponent(1.0)
                    default:
                        break
                    }
                    return
                } else {
                    cell.dateLabel.textColor = selectedMonthColor
                }
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    if workout.contains(where: { $0.key.contains("\(cellState.day.rawValue)") }) {
                        guard let tagColor = workout["tagColor"] else { return }
                        switch tagColor {
                        case "red":
                            cell.dateLabel.textColor = red.withAlphaComponent(0.75)
                        case "orange":
                            cell.dateLabel.textColor = orange.withAlphaComponent(0.75)
                        case "green":
                            cell.dateLabel.textColor = green.withAlphaComponent(0.75)
                        case "lightBlue":
                            cell.dateLabel.textColor = lightBlue.withAlphaComponent(0.75)
                        case "blue":
                            cell.dateLabel.textColor = blue.withAlphaComponent(0.75)
                        case "purple":
                            cell.dateLabel.textColor = purple.withAlphaComponent(0.75)
                        default:
                            break
                        }
                        return
                    } else {
                        cell.dateLabel.textColor = monthColor
                    }
                } else {
                    if workout.contains(where: { $0.key.contains("\(cellState.day.rawValue)") }) {
                        guard let tagColor = workout["tagColor"] else { return }
                        switch tagColor {
                        case "red":
                            cell.dateLabel.textColor = red.withAlphaComponent(0.25)
                        case "orange":
                            cell.dateLabel.textColor = orange.withAlphaComponent(0.25)
                        case "green":
                            cell.dateLabel.textColor = green.withAlphaComponent(0.25)
                        case "lightBlue":
                            cell.dateLabel.textColor = lightBlue.withAlphaComponent(0.25)
                        case "blue":
                            cell.dateLabel.textColor = blue.withAlphaComponent(0.25)
                        case "purple":
                            cell.dateLabel.textColor = purple.withAlphaComponent(0.25)
                        default:
                            break
                        }
                        return
                    } else {
                        cell.dateLabel.textColor = outsideMonthColor
                    }
                }
            }
        }
    }
    
    func handleCellEvents(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CalendarCollectionViewCell else { return }
        
        dateFormatter.dateFormat = "yyyy MM dd"
        
        if dateFormatter.string(from: cellState.date) <= dateFormatter.string(from: Date()) {
            for event in events {
                if event.contains(where: { $0.key == dateFormatter.string(from: cellState.date) }) {
                    guard let tagColor = event["tagColor"] else { return }
                    cell.redEventImageView.isHidden = false
                    cell.redEventImageView.image =  UIImage(named: tagColor)
                    guard let alpha = cell.dateLabel.textColor.cgColor.components?.last else { return }
                    cell.redEventImageView.alpha = alpha
                    return
                } else {
                    cell.redEventImageView.isHidden = true
                }
            }
        } else {
            cell.redEventImageView.isHidden = true
        }
    }
    
    func setupViewsForCalendar(from visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date,
            let startDate = startDate,
            let endDate = endDate else { return }
        
        dateFormatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = dateFormatter.string(from: date)
        
        if dateFormatter.string(from: date) == dateFormatter.string(from: startDate) {
            calendarLeftArrow.alpha = 0.25
        } else {
            calendarLeftArrow.alpha = 1.0
        }
        
        if dateFormatter.string(from: date) == dateFormatter.string(from: endDate) {
            calendarRightArrow.alpha = 0.25
        } else {
            calendarRightArrow.alpha = 1.0
        }
        
    }
    
    func dateSelected(cellState: CellState) {
        dateFormatter.dateFormat = "yyyy MM dd"
        
        eventsForSelectedDay = []
        scheduledForSelectedDay = []
        if dateFormatter.string(from: cellState.date) <= dateFormatter.string(from: Date()) {
            for event in events {
                if event.contains(where: { $0.key == dateFormatter.string(from: cellState.date) }) {
                    eventsForSelectedDay.append(event)
                }
            }
        }
        
        if dateFormatter.string(from: cellState.date) >= dateFormatter.string(from: Date()) {
            for workout in scheduled {
                if workout.contains(where: { $0.key.contains("\(cellState.day.rawValue)") }) {
                    scheduledForSelectedDay.append(workout)
                }
            }
        }
        
        tableView.reloadData()
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        if WorkoutCompletedController.shared.workoutsCompleted.count > 0 {
            if let startDate = WorkoutCompletedController.shared.workoutsCompleted[0].date {
                let startString = dateFormatter.string(from: startDate as Date)
                self.startDate = dateFormatter.date(from: startString)
                
                let today = Date()
                let todayString = dateFormatter.string(from: today)
                self.endDate = dateFormatter.date(from: todayString)
            }
        } else {
            let today = Date()
            let todayString = dateFormatter.string(from: today)
            self.endDate = dateFormatter.date(from: todayString)
            self.startDate = dateFormatter.date(from: todayString)
        }
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarDateCell", for: indexPath) as? CalendarCollectionViewCell else { return CalendarCollectionViewCell() }
        cell.dateLabel.text = cellState.text
        
        handleCellSelectedColor(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        dateSelected(cellState: cellState)
        handleCellSelectedColor(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelectedColor(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsForCalendar(from: visibleDates)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return eventsForSelectedDay.count
        }
        return scheduledForSelectedDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? CalendarEventTableViewCell,
                let tagColor = eventsForSelectedDay[indexPath.row]["tagColor"],
                let index = eventsForSelectedDay[indexPath.row]["index"],
                let workoutIndex = Int(index) else { return CalendarEventTableViewCell() }
            cell.workoutNameLabel.text = eventsForSelectedDay[indexPath.row]["name"]
            cell.colorTagImageView.image = UIImage(named: "\(tagColor)")
            cell.timeLabel.text = "\(Int(WorkoutCompletedController.shared.workoutsCompleted[workoutIndex].time / 60)) mins"
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? CalendarEventTableViewCell,
            let tagColor = scheduledForSelectedDay[indexPath.row]["tagColor"] else { return CalendarEventTableViewCell() }
        cell.workoutNameLabel.text = scheduledForSelectedDay[indexPath.row]["name"]
        cell.colorTagImageView.image = UIImage(named: "\(tagColor)")
        cell.timeLabel.text = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if eventsForSelectedDay.count == 0 {
                return nil
            }
            return "Workouts Completed"
        }
        if scheduledForSelectedDay.count == 0 {
            return nil
        }
        return "Scheduled Workouts"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.white
        }
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 41.0/255.0, green: 35.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let eventSelectedDict = eventsForSelectedDay[indexPath.row]
            guard let indexString = eventSelectedDict["index"],
                let index = Int(indexString),
                let workoutCompletedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "workoutCompletedVC") as? WorkoutCompletedViewController else { return }
            
            
            workoutCompletedVC.workoutCompleted = WorkoutCompletedController.shared.workoutsCompleted[index]
            navigationController?.pushViewController(workoutCompletedVC, animated: true)
        } else if indexPath.section == 1 {
            let scheduledWorkoutSelectedDict = scheduledForSelectedDay[indexPath.row]
            guard let indexString = scheduledWorkoutSelectedDict["index"],
                let index = Int(indexString) else { return }
            
            let actualWorkout = ActualWorkoutController.shared.copyWorkout(WorkoutController.shared.workouts[index])
            WorkoutCompletedController.shared.createPendingWorkoutCompleted(actualWorkout: actualWorkout)
            ActualWorkoutController.shared.selectedWorkout = actualWorkout
            performSegue(withIdentifier: "toStartWorkout", sender: nil)
        }
    }
    
}
