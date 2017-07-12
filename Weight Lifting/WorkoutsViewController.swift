//
//  ViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 6/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class WorkoutsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = CustomImageFlowLayout()
        
        self.title = "Workouts"

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



