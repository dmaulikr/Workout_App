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
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(super.dismissKeyboard))
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
        
        
        /*
         create session
         for each exercise create a lift for the exercise
         save session
         */
        
        var cells : [ExerciseToLogTableViewCell] = [ExerciseToLogTableViewCell]()
        
        for cell in self.tableView.visibleCells {
            if let exerciseCell = cell as? ExerciseToLogTableViewCell {
                cells.append(exerciseCell)
            }
        }
        
        for element in cells {
            print (element.name.text!)
        }
        
        var allEntered : Bool = true
        
        for cell in cells {
            if cell.liftAmountText.text == "" {
                allEntered = false
            }
        }
        
        if (allEntered == true) {
            
            let newSession : Session = NSEntityDescription.insertNewObject(forEntityName: String(describing: Session.self), into: DatabaseController.getContext()) as! Session
            
            for exercise in cells {
                let newLift : Lift = NSEntityDescription.insertNewObject(forEntityName: String(describing: Lift.self), into: DatabaseController.getContext()) as! Lift
                newLift.lifted = Int16(exercise.liftAmountText.text!)!
                
                
             
                
                for exerciseTemp in exercises {
                    if (exerciseTemp.name == exercise.name.text) {
                        newLift.exercise = exerciseTemp
                    }
                }
                
                newSession.date = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SelectDateTableViewCell).dataPicker.date as NSDate
                
                newSession.workout = workout
                
                newSession.addToLifts(newLift)
                
            }
            
            DatabaseController.saveContext()

            
            
            
            _ = self.navigationController?.popViewController(animated: true)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a weight for each exercise", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        
        
        
        
        
        
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
            cell.exerciseImage2.image = UIImage(data: exercises[indexPath.row - 1].image! as Data,scale: 7.0)
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






