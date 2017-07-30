//
//  ChartXAxisFormatter.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 29/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import Foundation
import Charts

class ChartXAxisFormatter: NSObject, IAxisValueFormatter {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }

    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
            let referenceTimeInterval = referenceTimeInterval
            else {
                return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
    
}
