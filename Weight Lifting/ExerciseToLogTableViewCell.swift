//
//  ExerciseToLogTableViewCell.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 17/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class ExerciseToLogTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var exerciseImage2: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var numSets: UILabel!
    @IBOutlet weak var numReps: UILabel!
    
    @IBOutlet weak var liftAmountText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        liftAmountText.keyboardType = UIKeyboardType.decimalPad
        

        
        
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
