//
//  MinutesValueFormatter.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/10/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import Foundation
import Charts

public class MinutesValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "MM-dd"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
