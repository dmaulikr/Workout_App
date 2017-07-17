//
//  LogWorkoutTableViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 17/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class LogWorkoutTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var chosenWorkout = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = chosenWorkout
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
   
}
