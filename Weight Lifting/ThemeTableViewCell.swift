//
//  ThemeTableViewCell.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 20/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var themeSegmentedController: UISegmentedControl!
    @IBOutlet weak var expandImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func themeSegmentClicked(_ sender: Any) {
    }
}
