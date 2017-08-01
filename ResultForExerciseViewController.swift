//
//  ResultForExerciseViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 24/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData
import Charts


class ResultForExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedExercise = ""
    
    var exercise : Exercise = Exercise()
    var lifts : [Lift] = [Lift]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        let context = DatabaseController.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        fetchRequest.predicate = NSPredicate(format: "name = %@", self.selectedExercise)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedExercises = try context.fetch(fetchRequest) as! [Exercise]
            if (fetchedExercises.count == 1) {
                exercise = fetchedExercises[0]
                lifts = exercise.lifts?.allObjects as! [Lift]
                
            }
        } catch {
            print("error")
        }
        
        self.title = exercise.name
        
        updateChartWithData()
        
        print(selectedExercise)
        
        
    }
    
    
    func updateChartWithData () {
        
        
        
        struct objectStruct {
            var date : Date
            var value : Int
        }
        
        var exercisesLifts = [objectStruct]()
        
        
        var referenceTimeInterval: TimeInterval = 0
        
        
        for lift in lifts {
            print("\(lift.exercise!.name ?? "no name provided"): \(lift.lifted)kg")
            
            let newLift = objectStruct(date: lift.session?.date! as! Date, value: Int(lift.lifted))
            exercisesLifts.append(newLift)
            
        }
        
        
        
        
        //sort array in results object
        
        var  sortedAboveIndex = exercisesLifts.count
        repeat {
            var lastSwapIndex = 0
            
            for i in 1..<sortedAboveIndex {
                if (((exercisesLifts[i - 1] ).date) > (exercisesLifts[i]).date) {
                    let temp: objectStruct = (exercisesLifts[i - 1] )
                    exercisesLifts[i - 1] = (exercisesLifts[i] )
                    exercisesLifts[i]  = temp
                    
                    lastSwapIndex = i
                }
            }
            
            sortedAboveIndex = lastSwapIndex
            
        } while (sortedAboveIndex != 0)
        
        
        
        
        
        var graphResults : [ChartDataEntry] = [ChartDataEntry]()
        
        // For each exercise, create a line to add to the chart
        
        if let minTimeInterval = ((exercisesLifts).map { $0.date.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
        
        
        // Define chart entries for each lift in the exercise
        
        for object in exercisesLifts {
            let timeInterval = object.date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let yValue = object.value
            let entry = ChartDataEntry(x: xValue, y: Double(yValue))
            graphResults.append(entry)
        }
        
        
        
        // Add the datasets to the data
        let data = LineChartData()
        var colorCode = 0
        
        let dataset = LineChartDataSet(values: graphResults, label: exercise.name)
        dataset.colors = [NSUIColor.black]
        dataset.drawCirclesEnabled = true
        dataset.drawCircleHoleEnabled = false
        dataset.circleRadius = CGFloat(2)
        dataset.circleColors = [NSUIColor.black]
        data.addDataSet(dataset)
        colorCode = colorCode + 1
        
        
        
        self.chartView.data = data
        
        
        
        // Define chart xValues formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        chartView.xAxis.valueFormatter = xValuesNumberFormatter
        
        self.chartView.data?.setDrawValues(false)
        self.chartView.gridBackgroundColor = NSUIColor.white
        self.chartView.xAxis.drawGridLinesEnabled = false;
        self.chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        self.chartView.chartDescription?.text = exercise.name
        
        
        self.chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 136
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseForExerciseResultsCell", for: indexPath) as! ExerciseForExerciseListResultsTableViewCell
            
            cell.exerciseNameLabel.text = exercise.name
            cell.exerciseImageView.image = UIImage(data: exercise.image! as Data)
            cell.repNumLabel.text = exercise.repNum
            cell.setNumLabel.text = exercise.setNum
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "liftResultsForExerciseCell", for: indexPath) as! LiftResultsForExerciseTableViewCell
            if let date = lifts[indexPath.row].session?.date {
                cell.dateLabel.text = String(describing: date)
            }
            
            cell.weightLabel.text = String(lifts[indexPath.row].lifted)
            return cell
        }
        
    }
    

}
