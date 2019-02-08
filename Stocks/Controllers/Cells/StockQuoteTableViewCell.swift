//
//  StockQuoteTableViewCell.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/17/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

class StockQuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    private var dayChange: String?
    
    func set(dayChange: String?) {
        guard let dayChange = dayChange else { return }
        self.dayChange = dayChange
        
        switch Double(dayChange)!.compare(with: 0) {
        case .equal:
            changeButton.setTitle("-", for: .normal)
            changeButton.backgroundColor = UIColor.aluminum
        case .greater:
            changeButton.backgroundColor = UIColor.leaf
            changeButton.setTitle("+" + dayChange, for: .normal)
        case .less:
            changeButton.backgroundColor = UIColor.lava
            fallthrough
        default:
            changeButton.setTitle(dayChange, for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    	super.setSelected(selected, animated: animated)
        let selectionBackgroundView = UIView()
        selectionBackgroundView.backgroundColor = UIColor.nasa.withAlphaComponent(0.5)
        selectedBackgroundView = selectionBackgroundView
        nameLabel.highlightedTextColor = UIColor.white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        set(dayChange: self.dayChange)
    }
}
