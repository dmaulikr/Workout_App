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
