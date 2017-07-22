//
//  ExercisesViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 11/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class ExercisesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var exerciseNameArray = [String]()
    var repNumArray = [String]()
    var setNumArray = [String]()
    var imageArray = [UIImage]()

    var selectedExercise = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Exercises"
        
        self.fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ExercisesViewController.fetchData), name: NSNotification.Name(rawValue: "newExerciseCreated"), object: nil)
        
    }
    
    
    func fetchData() {
        let fetchRequest:NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try DatabaseController.getContext().fetch(fetchRequest)
            
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
                    
                    self.tableView.reloadData()
                }
            }
            
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseTableViewCell
        cell.exerciseLabel.text = exerciseNameArray[indexPath.row]
        cell.repsLabel.text = repNumArray[indexPath.row]
        cell.setsLabel.text = setNumArray[indexPath.row]
        cell.imageLabel.image = imageArray[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedExercise = self.exerciseNameArray[indexPath.row]
        performSegue(withIdentifier: "fromExerciseListToAddExercise", sender: nil)
        
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        self.selectedExercise = ""
        performSegue(withIdentifier: "fromExerciseListToAddExercise", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromExerciseListToAddExercise") {
            let destinationVC = segue.destination as! AddExerciseViewController
            destinationVC.chosenExercise = self.selectedExercise
        }
    }
    

    
    
    
}
