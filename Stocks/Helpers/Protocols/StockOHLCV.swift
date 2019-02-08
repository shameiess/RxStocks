//
//  StockBasicInfo.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/19/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

protocol StockOHLCV {
    var open: String! { get }
    var high: String! { get }
    var low: String! { get }
    var close : String? { get }
    var volume: String! { get }
}
