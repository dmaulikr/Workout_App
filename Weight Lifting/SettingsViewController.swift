//
//  SettingsViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 18/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var cellTapped:Bool = true
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 168
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorThemeCell", for: indexPath) as! ThemeTableViewCell
        
        return cell
        
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedRowIndex = indexPath
        currentRow = selectedRowIndex.row
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    */
    /*
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0){
            if indexPath.row == currentRow {
                if cellTapped == false {
                    cellTapped = true
                    
                    
                    //let cell = tableView.dequeueReusableCell(withIdentifier: "colorThemeCell", for: IndexPath(row: 0, section: 0)) as! ThemeTableViewCell
                    
                    //cell.expandImageView.transform.rotated(by: CGFloat(Double.pi))
                    //print("here")
                    
                    return 168
                } else {
                    cellTapped = false
                    return 70
                }
            }
            return 70
        } else {
            return 70
        }
        
    }
    */
}









