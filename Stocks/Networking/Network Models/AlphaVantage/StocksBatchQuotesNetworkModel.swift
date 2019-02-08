//
//  StocksBatchQuotesNetworkModel.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/17/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import Foundation

struct StocksBatchQuotesNetworkModel: Codable {
    let metaData: BatchMetaData
    let stockBatchQuotes: [[String: String]]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case stockBatchQuotes = "Stock Batch Quotes"
    }
}

struct BatchMetaData: Codable {
    let information, notes, timeZone: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case notes = "2. Notes"
        case timeZone = "3. Time Zone"
    }
}
