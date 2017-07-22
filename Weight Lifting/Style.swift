//
//  Style.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 20/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import Foundation
import UIKit

struct Style{
    
    static var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
    static var sectionHeaderTitleColor = UIColor.white
    static var sectionHeaderBackgroundColor = UIColor.black
    static var sectionHeaderBackgroundColorHighlighted = UIColor.gray
    static var sectionHeaderAlpha: CGFloat = 1.0

    static func themeDefault(){

        sectionHeaderTitleFont = UIFont(name: "Helvetica", size: 18)
        sectionHeaderTitleColor = UIColor.white
        sectionHeaderBackgroundColor = UIColor.blue
        sectionHeaderBackgroundColorHighlighted = UIColor.lightGray
        sectionHeaderAlpha = 0.8
    }

}
