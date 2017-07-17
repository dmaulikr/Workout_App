//
//  LogWorkoutTableViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 17/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class LogWorkoutTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var chosenWorkout = ""
    
    var workout : Workout = Workout()
    var exercises : [Exercise] = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = chosenWorkout
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tableView.addGestureRecognizer(tap)
        
        
        
        
        
        let context = DatabaseController.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        fetchRequest.predicate = NSPredicate(format: "name = %@", chosenWorkout)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedWorkouts = try context.fetch(fetchRequest) as! [Workout]
            if (fetchedWorkouts.count == 1) {
                workout = fetchedWorkouts[0]
                exercises = workout.exercises?.allObjects as! [Exercise]
                print("size of exersises = ")
                print(exercises.count)
            }
        } catch {
            print("error")
        }

        
        
        
        
        
        
    }


    
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count + 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! SelectDateTableViewCell
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseToLog", for: indexPath) as! ExerciseToLogTableViewCell
            cell.name.text = exercises[indexPath.row - 1].name
            cell.numSets.text = exercises[indexPath.row - 1].setNum
            cell.numReps.text = exercises[indexPath.row - 1].repNum
            //cell.imageView?.image = UIImage(data: exercises[indexPath.row - 1].image! as Data,scale:1.0)
            return cell

        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if (indexPath.row == 0) {
            return CGFloat(150)
        } else {
            return CGFloat(180)
        }
        
        
        
    }
   
}






