//
//  AddWorkoutViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 12/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class AddWorkoutViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var exerciseNameArray = [String]()
    var repNumArray = [String]()
    var setNumArray = [String]()
    var imageArray = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Workout"
        
        tableView.delegate = self
        tableView.dataSource = self
        self.hideKeyboardWhenTappedAround()

    }


    @IBAction func addExercisesButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "fromExerciseListToAddExerciseToWorkout", sender: nil)
    }

    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutName", for: indexPath) as! WorkoutNameTableViewCell
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseForWorkoutCell", for: indexPath) as! ExerciseForWorkoutTableViewCell
            cell.exerciseNameLabel.text = "Example name"
            cell.repNumLabel.text = "10"
            cell.setNumLabel.text = "3"
            cell.workoutImage.image = UIImage(named: "placeholderForAddExercise.png")
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            return 55
        } else {
            return 136
        }
        
    }

}
