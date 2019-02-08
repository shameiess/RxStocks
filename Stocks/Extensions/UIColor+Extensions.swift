//
//  UIColor+Extensions.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/19/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var lava: UIColor {
        return UIColor(red: 252/255, green: 33/255, blue: 70/255, alpha: 1)
    }
    
    class var leaf: UIColor {
        return UIColor.init(hex: 0x23A431)
    }
    
    class var aluminum: UIColor {
        return UIColor.init(hex: 0x8e8e93)
    }
    
    class var nasa: UIColor {
        return UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1)
    }
    
    class var sky: UIColor {
        return UIColor.init(hex: 0x5fc9f8)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            r: (hex >> 16) & 0xFF,
            g: (hex >> 8) & 0xFF,
            b: hex & 0xFF,
            alpha: alpha
        )
    }
    
    private convenience init(r: Int, g: Int, b: Int, alpha: CGFloat) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static func random() -> UIColor {
        return UIColor(hex: Int(CGFloat(arc4random()) / CGFloat(UINT32_MAX) * 0xFFFFFF))
    }
}
