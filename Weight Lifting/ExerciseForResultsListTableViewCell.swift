//
//  ExerciseForResultsListTableViewCell.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 24/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class ExerciseForResultsListTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var setNumLabel: UILabel!
    @IBOutlet weak var repNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
