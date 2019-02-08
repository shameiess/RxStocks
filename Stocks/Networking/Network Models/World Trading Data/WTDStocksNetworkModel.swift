//
//  WTDStocksNetworkModel.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/19/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

struct WTDStocksNetworkModel: Codable {
    let message: String?
    let symbolsRequested, symbolsReturned: Int
    let data: [[String: String]]
    
    enum CodingKeys: String, CodingKey {
        case message
        case symbolsRequested = "symbols_requested"
        case symbolsReturned = "symbols_returned"
        case data
    }
}
