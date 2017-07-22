//
//  ViewWorkoutViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 17/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class ViewWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutNameAndImageCell", for: indexPath) as! WorkoutNameForViewWorkoutTableViewCell
            
            cell.nameLabel.text = workout.name
            cell.workoutImage.image = UIImage(data: workout.image! as Data)
            cell.selectionStyle = UITableViewCellSelectionStyle.none

            
            return cell
        } else {
            //let cell = UITableViewCell()
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseInfoForViewWorkout", for: indexPath) as! ExerciseDetailsForViewWorkoutTableViewCell
            
            cell.exerciseNameLabel.text = exercises[indexPath.row - 1].name
            cell.setNumLabel.text = exercises[indexPath.row - 1].repNum
            cell.repNumLabel.text = exercises[indexPath.row - 1].setNum
            cell.exerciseImageView.image = UIImage(data: exercises[indexPath.row - 1].image! as Data)
            cell.selectionStyle = UITableViewCellSelectionStyle.none

            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 271
        } else {
            return 136
        }
    }
   

}
