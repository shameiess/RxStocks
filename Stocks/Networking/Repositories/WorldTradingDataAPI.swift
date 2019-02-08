//
//  WorldTradingDataAPI.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/19/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import Foundation

var WorldTradingDataEndpoint: String {
    return "https://www.worldtradingdata.com/api/v1"
}

var WTD_API_KEY: String {
    return "GQv0QU9Fu1dVCHRu3jjHpsQQtJuTFjLlHndr5pwb3TC8biQadr86Uz7iR4M4"
}

class WorldTradingDataAPI: Repository {
    
    //https://www.worldtradingdata.com/api/v1/stock?symbol=AAPL,TSLA,FB,AMZN,DIS&api_token=GQv0QU9Fu1dVCHRu3jjHpsQQtJuTFjLlHndr5pwb3TC8biQadr86Uz7iR4M4
    func fetchBatchQuotes(symbols: [String], success: @escaping (WTDStocksNetworkModel?) -> Void, failure: @escaping (Error?) -> Void) {
        let endpoint = "\(WorldTradingDataEndpoint)/stock"
        let parameters = ["symbol" : symbols.joined(separator: ","),
                          "api_token" : WTD_API_KEY]
        networkManager.get(endpoint: endpoint, parameters: parameters, responseModel: WTDStocksNetworkModel.self) { (result) in
            switch result {
            case .success(let batch):
                if let batch = batch as? WTDStocksNetworkModel {
                    success(batch)
                }
            case .failure(let error):
                failure(error)
            }
        }
	}
}
