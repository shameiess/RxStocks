//
//  Double+Extension.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/10/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import Foundation

extension Double {
    
    enum ComparisonResult {
        case equal
        case greater
        case less
    }
    
    func compare(with double: Double) -> ComparisonResult {
        if self < double {
            return .less
        }
        if self > double {
            return .greater
        }
        return .equal
    }
}
