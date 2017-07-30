//
//  ResultForWorkoutViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 23/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ResultForWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedWorkout = ""
    var chosenExercise = ""
    
    var exercises : [Exercise] = [Exercise]()
    var workout : Workout = Workout()
    
    var colorsForGraph : [[NSUIColor]] = [[NSUIColor.blue], [NSUIColor.red], [NSUIColor.purple], [NSUIColor.orange], [NSUIColor.gray],
                                          [NSUIColor.black], [NSUIColor.brown], [NSUIColor.cyan], [NSUIColor.darkGray], [NSUIColor.green]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let context = DatabaseController.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        fetchRequest.predicate = NSPredicate(format: "name = %@", self.selectedWorkout)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedWorkouts = try context.fetch(fetchRequest) as! [Workout]
            if (fetchedWorkouts.count == 1) {
                workout = fetchedWorkouts[0]
                exercises = workout.exercises?.allObjects as! [Exercise]
                
            }
        } catch {
            print("error")
        }
        
        self.title = workout.name
        updateChartWithData()
    }
    
    func updateChartWithData() {
        
        struct objectStruct {
            var date : Date
            var value : Int
        }
        
        var exercisesLifts = [String:[objectStruct]]()
        
        
        var referenceTimeInterval: TimeInterval = 0
        
        if (workout.session?.count)! > 0 {
            
            
            // Initialise exercisesLifts[]
            for exercise in workout.exercises?.allObjects as! [Exercise] {
                exercisesLifts[exercise.name!] = []
            }
            
            
            
            
            // Populate exercisesLifts[]
            for session in workout.session?.allObjects as! [Session] {
                print("Session Date: ",terminator: "")
                print(session.date ?? "no date provided")
                let lifts = session.lifts?.allObjects as! [Lift]
                
                for lift in lifts {
                    print("\(lift.exercise!.name ?? "no name provided"): \(lift.lifted)kg")
                    
                    let newLift = objectStruct(date: session.date! as Date, value: Int(lift.lifted))
                    exercisesLifts[lift.exercise!.name!]?.append(newLift)
                    
                }
                
            }
            
            
            //sort array in results object
            for exercise in exercisesLifts.keys {
                
               var  sortedAboveIndex = exercisesLifts[exercise]!.count
                repeat {
                    var lastSwapIndex = 0
                    
                    for i in 1..<sortedAboveIndex {
                        if (((exercisesLifts[exercise]![i - 1] ).date) > (exercisesLifts[exercise]![i]).date) {
                            let temp: objectStruct = (exercisesLifts[exercise]![i - 1] )
                            exercisesLifts[exercise]![i - 1] = (exercisesLifts[exercise]![i] )
                            exercisesLifts[exercise]![i]  = temp
                            
                            lastSwapIndex = i
                        }
                    }
                    
                    sortedAboveIndex = lastSwapIndex
                    
                } while (sortedAboveIndex != 0)
                
            }
            
        
            
            var graphResults : [String:[ChartDataEntry]] = [String:[ChartDataEntry]]()
            
            for exercise in workout.exercises?.allObjects as! [Exercise] {
                graphResults[exercise.name!] = []
            }
            
            
            // For each exercise, create a line to add to the chart
            for exercise in exercisesLifts.keys {
                
                if let minTimeInterval = ((exercisesLifts[exercise]!).map { $0.date.timeIntervalSince1970 }).min() {
                    referenceTimeInterval = minTimeInterval
                }
                
                
                // Define chart entries for each lift in the exercise
                var entries = [ChartDataEntry]()
                for object in exercisesLifts[exercise]! {
                    let timeInterval = object.date.timeIntervalSince1970
                    let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                    
                    let yValue = object.value
                    let entry = ChartDataEntry(x: xValue, y: Double(yValue))
                    entries.append(entry)
                }
                
                // Add each exercise's graph data to the dictionary of graph datas
                graphResults[exercise] = entries
                
            }
    
            
            
            // Add the datasets to the data
            let data = LineChartData()
            var colorCode = 0
            for key in graphResults {
                
                let dataset = LineChartDataSet(values: graphResults[key.key], label: key.key)
                dataset.colors = colorsForGraph[colorCode % colorsForGraph.count]
                dataset.drawCirclesEnabled = true
                dataset.drawCircleHoleEnabled = false
                dataset.circleRadius = CGFloat(2)
                dataset.circleColors = [NSUIColor.black]
                data.addDataSet(dataset)
                colorCode = colorCode + 1
                
            }
            
            self.chartView.data = data
            
        }
        
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

        self.chartView.chartDescription?.text = workout.name
        
        
        self.chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromResultsForWorkoutToResultsForExercise") {
            let destinationVC = segue.destination as! ResultForExerciseViewController
            destinationVC.selectedExercise = self.chosenExercise
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenExercise = ((tableView.cellForRow(at: indexPath) as! ExerciseForResultsListTableViewCell).exerciseNameLabel.text ?? "No title")
        performSegue(withIdentifier: "fromResultsForWorkoutToResultsForExercise", sender: nil)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exercises.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseForResultsListCell", for: indexPath) as! ExerciseForResultsListTableViewCell
        
        cell.exerciseNameLabel.text = exercises[indexPath.row].name
        cell.exerciseImageView.image = UIImage(data: exercises[indexPath.row].image! as Data)
        cell.setNumLabel.text = exercises[indexPath.row].setNum
        cell.repNumLabel.text = exercises[indexPath.row].repNum
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
}
