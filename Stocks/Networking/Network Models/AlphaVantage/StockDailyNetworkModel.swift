//
//  StockDailyNetworkModel.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/17/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import Foundation

struct StockDailyNetworkModel: Codable {
    let metaData: StockDailyMetaData
    let timeSeriesDaily: [String: TimeSeriesDaily]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

struct StockDailyMetaData: Codable {
    let information, symbol, lastRefreshed, outputSize: String
    let timeZone: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case outputSize = "4. Output Size"
        case timeZone = "5. Time Zone"
    }
}

struct TimeSeriesDaily: Codable, StockOHLCV {
    let open, high, low, volume: String!
    var close: String?
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
