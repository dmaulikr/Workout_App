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
    
    var allExerciseNameArray = [String]()
    var allRepNumArray = [String]()
    var allSetNumArray = [String]()
    var allImageArray = [UIImage]()
    
    var selectedExerciseNameArray = [String]()
    var selectedRepNumArray = [String]()
    var selectedSetNumArray = [String]()
    var selectedImageArray = [UIImage]()
    
    var chosenExercises = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllExerciseData()
        self.title = "Design Workout"
        
        tableView.delegate = self
        tableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
        
        if (selectedExerciseNameArray.count == 0) {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }

    }

    override func viewDidAppear(_ animated: Bool) {

        fetchAllExerciseData()
        
       
        
        print("initial selected exercises are:")
        for temp in chosenExercises {
            print(temp)
        }
        selectedExerciseNameArray.removeAll(keepingCapacity: false)
        selectedRepNumArray.removeAll(keepingCapacity: false)
        selectedSetNumArray.removeAll(keepingCapacity: false)
        selectedImageArray.removeAll(keepingCapacity: false)
        for exerciseName in chosenExercises {
            var i : Int = 0
            while (i < allExerciseNameArray.count) {
                //print("comparing: \(exerciseName) with \(allExerciseNameArray[i])")
                if (exerciseName == allExerciseNameArray[i]) {
                    
                    selectedExerciseNameArray.append(allExerciseNameArray[i])
                    selectedRepNumArray.append(allRepNumArray[i])
                    selectedSetNumArray.append(allSetNumArray[i])
                    selectedImageArray.append(allImageArray[i])
                }
                i = i + 1
            }
        }
        
        print("final selected exercises are:")
        for temp in selectedExerciseNameArray {
            print(temp)
        }
        
        if (selectedExerciseNameArray.count == 0) {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromExerciseListToAddExerciseToWorkout") {
            let destinationVC = segue.destination as! ExerciseListToForWorkoutViewController
            destinationVC.selectedExercises = selectedExerciseNameArray
        }
    }
    
    @IBAction func addExercisesButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "fromExerciseListToAddExerciseToWorkout", sender: nil)
    }

    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedExerciseNameArray.count + 1
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
            cell.exerciseNameLabel.text = selectedExerciseNameArray[indexPath.row - 1]
            cell.repNumLabel.text = selectedRepNumArray[indexPath.row - 1]
            cell.setNumLabel.text = selectedSetNumArray[indexPath.row - 1]
            cell.workoutImage.image = selectedImageArray[indexPath.row - 1]
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
        
    }
    
    func fetchAllExerciseData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if (results.count > 0) {
                allExerciseNameArray.removeAll(keepingCapacity: false)
                allRepNumArray.removeAll(keepingCapacity: false)
                allSetNumArray.removeAll(keepingCapacity: false)
                allImageArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject]{
                    
                    if let exerciseName = result.value(forKey: "name") as? String {
                        self.allExerciseNameArray.append(exerciseName)
                    }
                    
                    if let repNum = result.value(forKey: "repNum") as? String {
                        self.allRepNumArray.append(repNum)
                    }
                    
                    if let setNum = result.value(forKey: "setNum") as? String {
                        self.allSetNumArray.append(setNum)
                    }
                    
                    if let image = result.value(forKey: "image") as? Data {
                        self.allImageArray.append(UIImage(data: image)!)
                    }
                    
                    //self.tableView.reloadData()
                }
            }
            
        } catch {
            
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
