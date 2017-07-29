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
       
        
        if (workout.session?.count)! > 0 {

            
            var results : [String: [[NSDate:Int]]] = [String: [[NSDate:Int]]]()
            
            for exercise in workout.exercises?.allObjects as! [Exercise] {
                results[exercise.name!] = []
            }
            
            let sessions = workout.session?.allObjects as! [Session]
        
            for session in sessions {
                print("Session Date: ",terminator: "")
                print(session.date ?? "no date provided")
                let lifts = session.lifts?.allObjects as! [Lift]
                
                for lift in lifts {
                    print("\(lift.exercise!.name ?? "no name provided"): \(lift.lifted)kg")
                    results[lift.exercise!.name!]?.append([session.date! : Int(lift.lifted)])
                    
                }
                
            }
            
            print("Results size: \(results.count)")
            
            
            var graphResults : [String:[ChartDataEntry]] = [String:[ChartDataEntry]]()
            
            for exercise in workout.exercises?.allObjects as! [Exercise] {
                graphResults[exercise.name!] = []
            }
            
            

            for exercise in results.keys {
                var i = 0
                var ySeries : [ChartDataEntry] = []
                for allExercise in results[exercise]! {
                    
                    for date in allExercise.keys {
                        print("\(exercise) on date \(date): \(allExercise[date]!)kg")
                        
                        ySeries.append(ChartDataEntry(x: Double(i), y: Double(allExercise[date]!)))
                        
                        
                        i += 1
                    }
                    
                }
                graphResults[exercise] = ySeries
                
                
            }
            
            let data = LineChartData()
            
            var colorCode = 0
            for key in graphResults {
                let dataset = LineChartDataSet(values: graphResults[key.key], label: key.key)
                dataset.colors = colorsForGraph[colorCode % colorsForGraph.count]
                data.addDataSet(dataset)
                colorCode = colorCode + 1

            }
            //let dataset = LineChartDataSet(values: ySeries, label: "Hello")
            
            
            self.chartView.data = data
            
        }
        
        
        
        
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
