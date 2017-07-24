//
//  WorkoutListForResultsViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 18/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class WorkoutListForResultsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var workouts : [Workout] = [Workout]()
    
    var chosenWorkouts = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Results"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = CustomImageFlowLayout()
        
        fetchWorkouts()
        
        
        
        
    }
    
    
    func fetchWorkouts() {
        workouts.removeAll(keepingCapacity: false)
        let fetchRequest:NSFetchRequest<Workout> = Workout.fetchRequest()
        
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            for result in searchResults as [Workout]{
                workouts.append(result)
                print(result.name ?? "no name given")
            }
        }
        catch{
            print("Error: \(error)")
        }
        print("number of workouts: \(workouts.count)")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let cell = UICollectionViewCell()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workoutForResultsScreen", for: indexPath) as! WorkoutForResultsCollectionViewCell
        cell.workoutNameLabel.text = workouts[indexPath.row].name
        cell.workoutImageView.image = UIImage(data:workouts[indexPath.row].image! as Data)

        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0).cgColor
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected \(indexPath.row) named: \((collectionView.cellForItem(at: indexPath) as! WorkoutForResultsCollectionViewCell).workoutNameLabel.text ?? "No title")")
        
        self.chosenWorkouts = ((collectionView.cellForItem(at: indexPath) as! WorkoutForResultsCollectionViewCell).workoutNameLabel.text ?? "No title")
        
        performSegue(withIdentifier: "fromResultsWorkoutListToResultsForWorkout", sender: nil)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "fromResultsWorkoutListToResultsForWorkout") {
            let destinationVC = segue.destination as! ResultForWorkoutViewController
            destinationVC.selectedWorkout = self.chosenWorkouts
        }
        
        
    }
    
    

}










