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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = CustomImageFlowLayout()
        
        self.title = "Workouts"

    }


    override func viewDidAppear(_ animated: Bool) {
  
        
        fetchExercises()
        fetchWorkouts()
        
        
        
    }
    
    
    func fetchWorkouts() {
        
        let fetchRequest:NSFetchRequest<Workout> = Workout.fetchRequest()
        
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of workouts: \(searchResults.count)")
            
            for result in searchResults as [Workout]{
                print(result.name ?? "no name given")
            }
        }
        catch{
            print("Error: \(error)")
        }
        
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
        return 10
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! WorkoutsCollectionViewCell
        cell.workoutTitle.text = "hello"
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0).cgColor
        //cell.layer.borderColor = UIColor.light
        return cell
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



