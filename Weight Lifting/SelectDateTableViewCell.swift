//
//  SelectDateTableViewCell.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 17/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class SelectDateTableViewCell: UITableViewCell {

    @IBOutlet weak var dataPicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
