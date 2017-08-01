//
//  ExerciseListToForWorkoutViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 12/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

protocol SecondVCDelegate {
    func didFinishSecondVC(controller: ExerciseListToForWorkoutViewController)
}

class ExerciseListToForWorkoutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var exerciseNameArray = [String]()
    var repNumArray = [String]()
    var setNumArray = [String]()
    var imageArray = [UIImage]()
    
    var selectedExercises = [String]()
    
    @IBOutlet weak var exerciseTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        fetchAllExerciseData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        print("selectedExercises are:")
        for element in selectedExercises {
            print (element)
        }
        let cells = self.exerciseTableView.visibleCells as! Array<ExerciseWithButtonTableViewCell>
        
        for cell in cells {
            if (cell.imageSelected == true) {
                if (cell.exerciseNameLabel.text != "") {
                    if (!selectedExercises.contains(cell.exerciseNameLabel.text!)){
                        selectedExercises.append(cell.exerciseNameLabel.text!)
                    }
                }
            } else {
                if (selectedExercises.contains(cell.exerciseNameLabel.text!)) {
                    if let index = selectedExercises.index(of: cell.exerciseNameLabel.text!) {
                        selectedExercises.remove(at: index)
                    }
                }
            }
        }

        for element in selectedExercises {
            print (element)
        }
        _ = self.navigationController?.popViewController(animated: true)

        let previousViewController = self.navigationController?.viewControllers.last as! AddWorkoutViewController
        
        previousViewController.chosenExercises.removeAll(keepingCapacity: false)
        previousViewController.chosenExercises = self.selectedExercises
        

    }

    func fetchAllExerciseData() {
        

        
        let request:NSFetchRequest<Exercise> = Exercise.fetchRequest()

//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try DatabaseController.getContext().fetch(request)
            
            if (results.count > 0) {
                exerciseNameArray.removeAll(keepingCapacity: false)
                repNumArray.removeAll(keepingCapacity: false)
                setNumArray.removeAll(keepingCapacity: false)
                imageArray.removeAll(keepingCapacity: false)
                
                for result in results as [NSManagedObject]{
                    
                    if let exerciseName = result.value(forKey: "name") as? String {
                        self.exerciseNameArray.append(exerciseName)
                    }
                    
                    if let repNum = result.value(forKey: "repNum") as? String {
                        self.repNumArray.append(repNum)
                    }
                    
                    if let setNum = result.value(forKey: "setNum") as? String {
                        self.setNumArray.append(setNum)
                    }
                    
                    if let image = result.value(forKey: "image") as? Data {
                        self.imageArray.append(UIImage(data: image)!)
                    }
                    
                    //self.tableView.reloadData()
                }
            }
            
        } catch {
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exerciseTableView.dequeueReusableCell(withIdentifier: "ExerciseForWorkoutCell", for: indexPath) as! ExerciseWithButtonTableViewCell
        
        cell.exerciseNameLabel.text = exerciseNameArray[indexPath.row]
        cell.repNumLabel.text = repNumArray[indexPath.row]
        cell.setNumLabel.text = setNumArray[indexPath.row]
        cell.exerciseImageView.image = imageArray[indexPath.row]
        
        
        let cells = self.exerciseTableView.visibleCells as! Array<ExerciseWithButtonTableViewCell>
        
        for cellToChange in cells {
            if (cellToChange.imageSelected == true) {
                if (cellToChange.exerciseNameLabel.text != "") {
                    if (!selectedExercises.contains(cellToChange.exerciseNameLabel.text!)){
                        selectedExercises.append(cellToChange.exerciseNameLabel.text!)
                    }
                }
            } else {
                if (selectedExercises.contains(cellToChange.exerciseNameLabel.text!)) {
                    if let index = selectedExercises.index(of: cellToChange.exerciseNameLabel.text!) {
                        selectedExercises.remove(at: index)
                    }
                }
            }
        }

        
        
        if (alreadyTicked(name: exerciseNameArray[indexPath.row],nameArray: selectedExercises)) {
            print("\(selectedExercises) does contain \(exerciseNameArray[indexPath.row])")
            print ("setting true for \(exerciseNameArray[indexPath.row])")
            cell.imageSelected = true
            cell.updateImage()
        } else {
            print("\(selectedExercises) does not contain \(exerciseNameArray[indexPath.row])")
            print ("setting false for \(exerciseNameArray[indexPath.row])")
            cell.imageSelected = false
            cell.updateImage()
        }
        
        return cell
    }
    
    func alreadyTicked(name:String,nameArray:[String]) -> Bool{
        if nameArray.contains(name) {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 136
        
        
    }
    
    
}







