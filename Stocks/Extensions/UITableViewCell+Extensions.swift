//
//  UITableViewCell+Extensions.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/17/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
