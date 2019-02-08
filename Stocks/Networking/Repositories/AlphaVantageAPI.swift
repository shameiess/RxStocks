//
//  AlphaVantageAPI.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/16/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import Foundation

var AlphaVantageEndpoint: String {
    return "https://www.alphavantage.co"
}

var AV_API_KEY: String {
    return "TVQDTQHCVI0001VV"
}

typealias StocksBatchRequestCompletion = (StocksBatchQuotesNetworkModel?, Error?) -> Void
typealias StockDailyRequestCompletion = (StockDailyNetworkModel?, Error?) -> Void
typealias StockIntradayRequestCompletion = (StockIntradayNetworkModel?, Error?) -> Void

class AlphaVantageAPI: Repository {
    
    //https://www.alphavantage.co/query?function=BATCH_QUOTES_US&symbols=AAPL,TSLA,FB,MFST,NFLX,DIS&apikey=TVQDTQHCVI0001VV
    func fetchBatchQuotes(symbols: [String], completion: StocksBatchRequestCompletion?) {
        let endpoint = "\(AlphaVantageEndpoint)/query"
        let parameters = ["function" : "BATCH_QUOTES_US",
                          "symbols" : symbols.joined(separator: ","),
                          "apikey" : AV_API_KEY]
        networkManager.get(endpoint: endpoint, parameters: parameters, responseModel: StocksBatchQuotesNetworkModel.self) { (result) in
            switch result {
            case .success(let batch):
                if let batch = batch as? StocksBatchQuotesNetworkModel {
                    completion?(batch, nil)
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    //https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=MSFT&apikey=TVQDTQHCVI0001VV
    func fetchDaily(symbol: String, completion: StockDailyRequestCompletion?) {
        let endpoint = "\(AlphaVantageEndpoint)/query"
        let parameters = ["function" : "TIME_SERIES_DAILY",
                          "symbol" : symbol,
                          "apikey" : AV_API_KEY,
                          "outputsize" : "compact"]
        networkManager.get(endpoint: endpoint, parameters: parameters, responseModel: StockDailyNetworkModel.self) { (result) in
            switch result {
            case .success(let stock):
                if let stock = stock as? StockDailyNetworkModel {
                    completion?(stock, nil)
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
        
    }
    
    //https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=AAPL&interval=1min&apikey=TVQDTQHCVI0001VV
    func fetchIntraday(symbol: String, minInterval: Int, completion: StockIntradayRequestCompletion?) {
        let endpoint = "\(AlphaVantageEndpoint)/query"
        let parameters = ["function" : "TIME_SERIES_INTRADAY",
                          "symbol" : symbol,
                          "interval" : String(minInterval) + "min",
                          "apikey" : AV_API_KEY]
        networkManager.get(endpoint: endpoint, parameters: parameters, responseModel: StockIntradayNetworkModel.self) { (result) in
            switch result {
            case .success(let stock):
                if let stock = stock as? StockIntradayNetworkModel {
                    completion?(stock, nil)
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }

    }
}

