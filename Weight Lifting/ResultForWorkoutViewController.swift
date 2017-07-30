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
        
        var resultsObject = [String:[objectStruct]]()
        var referenceTimeInterval: TimeInterval = 0
        
        if (workout.session?.count)! > 0 {
            
            
            var results : [String: [[NSDate:Int]]] = [String: [[NSDate:Int]]]()
            
            
            // Initialise resultsObject[]
            for exercise in workout.exercises?.allObjects as! [Exercise] {
                results[exercise.name!] = []
                resultsObject[exercise.name!] = []
            }
            
            
            
            
            // Populate resultsObject[]
            for session in workout.session?.allObjects as! [Session] {
                print("Session Date: ",terminator: "")
                print(session.date ?? "no date provided")
                let lifts = session.lifts?.allObjects as! [Lift]
                
                for lift in lifts {
                    print("\(lift.exercise!.name ?? "no name provided"): \(lift.lifted)kg")
                    results[lift.exercise!.name!]?.append([session.date! : Int(lift.lifted)])
                    
                    let newLift = objectStruct(date: session.date! as Date, value: Int(lift.lifted))
                    resultsObject[lift.exercise!.name!]?.append(newLift)
                    
                }
                
            }
            
            
            //sort array in results object
            for exercise in resultsObject.keys {
                
               var  sortedAboveIndex = resultsObject[exercise]!.count
                repeat {
                    var lastSwapIndex = 0
                    
                    for i in 1..<sortedAboveIndex {
                        if (((resultsObject[exercise]![i - 1] ).date) > (resultsObject[exercise]![i]).date) {
                            let temp: objectStruct = (resultsObject[exercise]![i - 1] )
                            resultsObject[exercise]![i - 1] = (resultsObject[exercise]![i] )
                            resultsObject[exercise]![i]  = temp
                            
                            lastSwapIndex = i
                        }
                    }
                    
                    sortedAboveIndex = lastSwapIndex
                    
                } while (sortedAboveIndex != 0)
                
            }
            
            
            
            
            print("Results size: \(results.count)")
            
            
            var graphResults : [String:[ChartDataEntry]] = [String:[ChartDataEntry]]()
            
            for exercise in workout.exercises?.allObjects as! [Exercise] {
                graphResults[exercise.name!] = []
            }
            
            
            // For each exercise, create a line to add to the chart
            for exercise in resultsObject.keys {
                
                if let minTimeInterval = ((resultsObject[exercise]!).map { $0.date.timeIntervalSince1970 }).min() {
                    referenceTimeInterval = minTimeInterval
                }
                
                
                // Define chart entries for each lift in the exercise
                var entries = [ChartDataEntry]()
                for object in resultsObject[exercise]! {
                    let timeInterval = object.date.timeIntervalSince1970
                    let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                    
                    let yValue = object.value
                    let entry = ChartDataEntry(x: xValue, y: Double(yValue))
                    entries.append(entry)
                }
                
                // Add each exercise's graph data to the dictionary of graph datas
                graphResults[exercise] = entries
                
            }
            
            
            // change hashmap into array of struct
            
            struct graphResultsStruct {
                var exercise : String
                var data : [ChartData]
            }
            
            
            // Sort array of struct by Date
            
            
            
            // Add the datasets to the data
            let data = LineChartData()
            var colorCode = 0
            for key in graphResults {
                
                let dataset = LineChartDataSet(values: graphResults[key.key], label: key.key)
                dataset.colors = colorsForGraph[colorCode % colorsForGraph.count]
                
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
        
        self.chartView.gridBackgroundColor = NSUIColor.white
        self.chartView.xAxis.drawGridLinesEnabled = false;
        self.chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        //self.chartView.chartDescription?.text = "LineChartView Example"
        
        
        self.chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        
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
