//
//  ExerciseWithButtonTableViewCell.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 12/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class ExerciseWithButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var setNumLabel: UILabel!
    @IBOutlet weak var repNumLabel: UILabel!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var tickImage: UIImageView!

    var imageSelected : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tickImage.image = UIImage(named: "untickedCircle.png")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExerciseWithButtonTableViewCell.changeTickImage))
        tickImage.isUserInteractionEnabled = true
        tickImage.addGestureRecognizer(gestureRecognizer)
    }
    
    func updateImage() {
        if (imageSelected == false) {
            tickImage.image = UIImage(named: "untickedCircle.png")
        } else {
            tickImage.image = UIImage(named: "tickedCircle.png")
        }
    }

    func changeTickImage() {
        if (imageSelected == false) {
            imageSelected = true
            tickImage.image = UIImage(named: "tickedCircle.png")
        } else {
            imageSelected = false
            tickImage.image = UIImage(named: "untickedCircle.png")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
