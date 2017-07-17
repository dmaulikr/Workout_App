//
//  LogWorkoutViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 17/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class LogWorkoutViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var workouts : [Workout] = [Workout]()

    var selectedWorkout = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomImageFlowLayout()
        fetchWorkouts()

    }

    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedWorkout = workouts[indexPath.row].name!
        performSegue(withIdentifier: "fromLogWorkoutListToLogWorkout", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromLogWorkoutListToLogWorkout") {
        
            let destinationVC = segue.destination as! LogWorkoutTableViewController
            destinationVC.chosenWorkout = self.selectedWorkout
            
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workouts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workoutCell", for: indexPath) as! LogWorkoutCollectionViewCell
        
        cell.workoutTitle.text = workouts[indexPath.row].name
        cell.workoutImage.image = UIImage(data:workouts[indexPath.row].image! as Data,scale:1.0)
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0).cgColor
        
        
        return cell
    }
    
 

}
