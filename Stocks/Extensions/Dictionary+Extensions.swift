//
//  Dictionary+Extensions.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/16/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import Foundation

extension Dictionary where Key: CustomStringConvertible, Value: Any {
    
    func stringFromHttpParameters() -> String {
        var parametersString = "?"
        for (key, value) in self {
            parametersString += key.description + "=" + String(describing: value) + "&"
        }
        return String(parametersString.dropLast())
    }
}
