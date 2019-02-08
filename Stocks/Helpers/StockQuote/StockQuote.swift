//
//  StockQuote.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/3/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import Foundation
import RxDataSources

struct StockQuote: StockOHLCV, Equatable {
    let symbol, open, high, low, price, volume: String!
    var close: String?
    var name: String?
    var dayChange: String?
    
    static func == (lhs: StockQuote, rhs: StockQuote) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}

struct SectionOfStockQuote {
    var header: String?
    var items: [StockQuote]
}

extension SectionOfStockQuote: SectionModelType {
    typealias Item = StockQuote
    
    init(original: SectionOfStockQuote, items: [StockQuote]) {
        self = original
        self.items = items
    }
}
