//
//  StocksViewModel.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/20/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import RxSwift
import RxCocoa
import RxCoreData

class StocksViewModel {
    
    // MARK: Private
    private var privateDataSource: Variable<[Stock]> = Variable([])
    private var stocks: [Stock] = []
    private let disposeBag = DisposeBag()
    private var coreDataManager: CoreDataManager!
    
    // MARK: Outputs
    public var dataSource: Observable<[Stock]>?
        
    // MARK: Inputs
    public var searchText = Variable("")
    
//    var stocks: [StockQuote]? {
//        return privateDataSource.value
//    }
    
    
    init(coreDataManager: CoreDataManager) {
//        dataSource = Observable<[Stock]>.create({ (subscriber) in
//            self.fetch(completion: { (stocks) in
//                subscriber.onNext(stocks)
//                subscriber.onCompleted()
//            })
//            return Disposables.create()
//        })
        self.coreDataManager = coreDataManager
        self.coreDataManager.loadPersistentStore(description: nil, completion: nil)
        
        self.fetch(completion: { (stocks) in
            self.privateDataSource.value = stocks
            self.stocks = stocks
        })
        dataSource = privateDataSource.asObservable()
        
        self.searchText.asObservable()
            .subscribe(onNext: { (query) in
                let query = query.lowercased()
                self.privateDataSource.value = self.stocks.filter{ ($0.symbol.lowercased().hasPrefix(query) || ($0.name.lowercased().contains(query))) }
            })
            .disposed(by: disposeBag)
    }
    
    // Add
    func add(itemTap: Driver<Void>) {
        itemTap.drive(onNext: { [weak self] _ in
//            let quote = StockQuote(symbol: "KEV", open: "$1000000", high: "$1000000", low: "$1000000", price: "$1000000", volume: "$1000000", close: nil, name: "KEVIN DURANT", dayChange: "+1000000")
            let stock = Stock(symbol: "PHUN", name: "Phunware Inc.", price: "1000000", dayChange: "1000000")
            _ = try? self?.coreDataManager.newBackgroundContext().rx.update(stock)
            self?.privateDataSource.value.append(stock)
            self?.stocks.append(stock)
        })
        .disposed(by: disposeBag)
    }
    
    // Delete
//    func delete(item index: IndexPath) {
//        self.privateDataSource.value.remove(at: index.row)
//        self.stocks.remove(at: index.row)
//    }
    
    func delete(model: Stock, index: IndexPath) {
        self.privateDataSource.value.remove(at: index.row)
        self.stocks.remove(at: index.row)
        do {
        	try self.coreDataManager.newBackgroundContext().rx.delete(model)
        } catch {
            print(error)
        }
    }
    
//    init(stocks: [StockQuote]? = nil) {
//        if let stocks = stocks {
//            self.stocks = stocks
//        } else {
//            fetch {
////                self.observables = Observable.just(stocks)
//            }
//        }
//    }
    
    func fetch(completion: @escaping ([Stock]) -> Void) {
        WorldTradingDataAPI().fetchBatchQuotes(symbols: ["AAPL","GOOG","TSLA","AMZN","FB", "PHUN"], success: { (batch) in
//            guard let stocks = batch?.data.map({ (stock) -> StockQuote in
//                StockQuote(symbol: stock["symbol"], open: stock["price_open"], high: stock["day_high"], low: stock["day_low"], price: stock["price"], volume: stock["volume"], close: nil, name: stock["name"], dayChange: stock["day_change"])
//            }) else { return }
            guard let stocks = batch?.data.map({ (stock) -> Stock in
                Stock(symbol: stock["symbol"]!, name: stock["name"]!, price: stock["price"]!, dayChange: stock["day_change"]!)
            }) else { return }
            
            for stock in stocks {
                _ = try? self.coreDataManager.newBackgroundContext().rx.update(stock)
            }
            self.fetchCachedStocks(completion: { (stocks) in
                completion(stocks)
            })
//            let backgroundContext = self.coreDataManager.newBackgroundContext()
//            backgroundContext.performAndWait {
//                Stock.deleteAll(context: backgroundContext)
//                var coreDataStocks = [Stock]()
//                for stock in stocks {
//                    let stock = Stock(data: stock, context: backgroundContext)
//                    coreDataStocks.append(stock)
//                }
//                self.coreDataManager.save(context: backgroundContext)
//                completion(coreDataStocks)
//            }
//            completion(stocks)
        }, failure: { (error) in
            print(error?.localizedDescription ?? "")
            self.fetchCachedStocks(completion: { (stocks) in
                completion(stocks)
            })
//            if let stocks = Stock.fetchStocks(predicate: nil, context: self.coreDataManager.viewContext) {
//                print(stocks)
////                completion(stocks)
//            }
        })
    }

    func fetchCachedStocks(completion: @escaping ([Stock]) -> Void) {
        let coreDataStocks = Stock.fetchStocks(predicate: nil, context: self.coreDataManager.viewContext)
        coreDataStocks.bind(onNext: { (stocks) in
            completion(stocks)
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Bindings
//    var reload: (() -> Void)?
}
