//
//  GradientView.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/9/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        return gradientLayer
    }()
    
    public var topColor: UIColor = .clear {
        didSet {
            updateGradientColors()
        }
    }
    public var bottomColor: UIColor = .black {
        didSet {
            updateGradientColors()
        }
    }
    
    public var cornerRadius: CGFloat? {
        didSet {
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(gradientLayer)
    }

    convenience init(frame: CGRect = .zero, topColor: UIColor, bottomColor: UIColor, horizontal: Bool = false) {
        self.init(frame: frame)
        self.topColor = topColor
        self.bottomColor = bottomColor
        if horizontal == true {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ?? bounds.width * 0.2).cgPath
        layer.mask = maskLayer
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
