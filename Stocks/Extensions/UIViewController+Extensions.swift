//
//  UIViewController+Extensions.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/7/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setMultiLineTitle() {
    	guard let navigationBar = self.navigationController?.navigationBar else { return }
        for views in navigationBar.subviews {
            for subview in views.subviews {
                if let largeLabel = subview as? UILabel {
                    largeLabel.text = self.title
                    largeLabel.numberOfLines = 0
                    largeLabel.lineBreakMode = .byWordWrapping
                }
            }
        }
    }
}
