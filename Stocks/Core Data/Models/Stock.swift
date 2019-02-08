//
//  Stock.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/7/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import CoreData
import RxSwift
import RxDataSources
import RxCoreData

struct Stock {
    var symbol: String
    var name: String
    var price: String
    var dayChange: String
}

//extension Stock {
//
//    @discardableResult
//    convenience init(data: StockQuote, context: NSManagedObjectContext) {
//        self.init(context: context)
//
//        symbol = data.symbol
//        name = data.name
//        price = data.price
//        dayChange = data.dayChange
//    }
//
//    class func fetchStocks(predicate: NSPredicate?, context: NSManagedObjectContext) -> [Stock]? {
//        var stocks: [Stock]?
//        do {
//            let stocksRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
//            stocksRequest.predicate = predicate
//            try stocks = context.fetch(stocksRequest)
//        } catch {
//            print(error.localizedDescription)
//        }
//        return stocks
//    }
//
//    class func deleteAll(context: NSManagedObjectContext) {
//        if let stocks = fetchStocks(predicate: nil, context: context) {
//            for stock in stocks {
//                context.delete(stock)
//            }
//        }
//    }
//}

extension Stock: IdentifiableType {
    public typealias Identity = String

    public var identity: Identity { return symbol }
}

extension Stock: Persistable {
    typealias T = NSManagedObject

    static var entityName: String {
        return "Stock"
    }

    static var primaryAttributeName: String {
        return "symbol"
    }

    init(entity: T) {
        symbol = entity.value(forKey: "symbol") as! String
        name = entity.value(forKey: "name") as! String
        price = entity.value(forKey: "price") as! String
        dayChange = entity.value(forKey: "dayChange") as! String
    }

    func update(_ entity: NSManagedObject) {
        entity.setValue(symbol, forKey: "symbol")
        entity.setValue(name, forKey: "name")
        entity.setValue(price, forKey: "price")
        entity.setValue(dayChange, forKey: "dayChange")
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}

extension Stock {
    
    static func fetchStocks(predicate: NSPredicate?, context: NSManagedObjectContext) -> Observable<[Stock]> {
        return context.rx.entities(self, predicate: predicate, sortDescriptors: nil)
    }
}
