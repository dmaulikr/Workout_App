//
//  ViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 6/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class WorkoutsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var workouts : [Workout] = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = CustomImageFlowLayout()
        
        self.title = "Workouts"
        fetchExercises()
        fetchWorkouts()
        collectionView.reloadData()


    }


    override func viewDidAppear(_ animated: Bool) {
  
        
        fetchExercises()
        fetchWorkouts()
        
        collectionView.reloadData()
        
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
    
    
    func fetchExercises() {
        
        let fetchRequest:NSFetchRequest<Exercise> = Exercise.fetchRequest()
        
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of exercises: \(searchResults.count)")
            
            for result in searchResults as [Exercise]{
                print(result.name ?? "no name given")
            }
        }
        catch{
            print("Error: \(error)")
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return workouts.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! WorkoutsCollectionViewCell
        cell.workoutTitle.text = workouts[indexPath.row].name
        cell.workoutImage.image = UIImage(data:workouts[indexPath.row].image! as Data,scale:1.0)
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0).cgColor
        //cell.layer.borderColor = UIColor.light
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected \(indexPath.row) named: \((collectionView.cellForItem(at: indexPath) as! WorkoutsCollectionViewCell).workoutTitle.text ?? "No title")")
        
        //add view workout screen here
        
    }
    
    
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "fromWorkoutCollectionToAddWorkout", sender: nil)
        
    }

    
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



