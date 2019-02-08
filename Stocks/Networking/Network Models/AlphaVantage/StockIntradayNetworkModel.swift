//
//  StockIntradayNetworkModel.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/16/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import Foundation

struct StockIntradayNetworkModel: Decodable {
    
    let metaData: StockIntradayMetaData
    let series: [String: TimeSeriesIntraday]
    
    init(metaData: StockIntradayMetaData, series: [String: TimeSeriesIntraday]) {
        self.metaData = metaData
        self.series = series
    }
    
    struct CodingKeys: CodingKey {
        var intValue: Int?
        var stringValue: String
        
        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
        init?(stringValue: String) { self.stringValue = stringValue }
        
        static let name = CodingKeys(stringValue: "")!
        static func makeKey(name: String) -> CodingKeys {
            return CodingKeys(stringValue: name)!
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
        var metaData: StockIntradayMetaData!
        var series: [String: TimeSeriesIntraday]!
        for key in container.allKeys {
            switch key.stringValue {
            case "Meta Data":
                metaData = try container.decode(StockIntradayMetaData.self, forKey: .makeKey(name: key.stringValue))
            default:
                series = try container.decode([String: TimeSeriesIntraday].self, forKey: .makeKey(name: key.stringValue))
            }
        }
        self.init(metaData: metaData, series: series) // initializing our struct
    }
}

/*
 1. Information: "Daily Prices (open, high, low, close) and Volumes",
 2. Symbol: "MSFT",
 3. Last Refreshed: "2018-08-17 15:16:48",
 4. Output Size: "Compact",
 5. Time Zone: "US/Eastern"
 */

struct StockIntradayMetaData: Codable {
    var information, symbol, lastRefreshed, outputSize, timeZone: String
    var interval: String?
    
//    init(information: String, symbol: String, lastRefreshed: String, outputSize: String, timeZone: String, interval: String?) {
//        self.information = information
//        self.symbol = symbol
//        self.lastRefreshed = lastRefreshed
//        self.outputSize = outputSize
//        self.timeZone = timeZone
//        self.interval = interval
//    }
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
//        case outputSize = "4. Output Size"
//        case timeZone = "5. Time Zone"
        case interval = "4. Interval"
        case outputSize = "5. Output Size"
        case timeZone = "6. Time Zone"
    }
    
//    struct PhantomKeys: CodingKey {
//        var intValue: Int?
//        var stringValue: String
//
//        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
//        init?(stringValue: String) { self.stringValue = stringValue }
//
//        static let name = CodingKeys(stringValue: "")!
//        static func makeKey(name: String) -> CodingKeys {
//            return CodingKeys(stringValue: name)!
//        }
//    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        for key in container.allKeys {
//
//        }
//    }
}

struct TimeSeriesIntraday: Codable, StockOHLCV {
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
