//
//  ResultForExerciseViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 24/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class ResultForExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseForExerciseResultsCell", for: indexPath) as! ExerciseForExerciseListResultsTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "liftResultsForExerciseCell", for: indexPath) as! LiftResultsForExerciseTableViewCell
            
            return cell
        }
        
    }

}
