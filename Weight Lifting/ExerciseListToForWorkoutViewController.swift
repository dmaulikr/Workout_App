//
//  ExerciseListToForWorkoutViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 12/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class ExerciseListToForWorkoutViewController: UIViewController {

    var exerciseNameArray = [String]()
    var repNumArray = [String]()
    var setNumArray = [String]()
    var imageArray = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    func fetchAllWorkoutData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if (results.count > 0) {
                exerciseNameArray.removeAll(keepingCapacity: false)
                repNumArray.removeAll(keepingCapacity: false)
                setNumArray.removeAll(keepingCapacity: false)
                imageArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject]{
                    
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
}
