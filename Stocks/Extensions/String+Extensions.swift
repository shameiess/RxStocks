//
//  String+Extensions.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/10/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import Foundation

extension String {
    
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: self)
    }
}
