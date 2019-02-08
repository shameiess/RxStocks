//
//  MainStocksViewController.swift
//  Stocks
//
//  Created by Kevin Nguyen on 8/16/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources
import Differentiator
import CoreData
import RxCoreData

class MainStocksViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    private let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    
    // MARK: - View Model
    lazy var viewModel: StocksViewModel = {
        return StocksViewModel(coreDataManager: coreDataManager)
    }()
    
    // MARK: - Private
    private let coreDataManager = CoreDataManager()
    private let disposeBag = DisposeBag()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
//        setupDate()
        setupSearchController()
        
        // MARK: - View Model RX Bindings
        
        // MARK: Datasource
//        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfStockQuote>(
//            configureCell: { dataSource, tableView, indexPath, item in
//                let cell = tableView.dequeueReusableCell(withIdentifier: StockQuoteTableViewCell.reusableIdentifier, for: indexPath) as! StockQuoteTableViewCell
////                cell.textLabel?.text = "Item \(item.anInt): \(item.aString) - \(item.aCGPoint.x):\(item.aCGPoint.y)"
//                cell.symbolLabel.text = item.symbol
//                cell.priceLabel.text = item.price
//                cell.nameLabel.text = item.name ?? item.high
//                cell.set(dayChange: item.dayChange)
//                return cell
//        })
//
//        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
//            return true
//        }
//
//        dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
//            return true
//        }
//        print(viewModel.rxdatasource)
//        Observable.just(viewModel.rxdatasource)
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
//        managedObjectContext.rx.entities(Stock.self)
//            .bind(to: tableView.rx.items(cellIdentifier: StockQuoteTableViewCell.reusableIdentifier, cellType: StockQuoteTableViewCell.self))
//            { (row, stock, cell) in
//                cell.symbolLabel.text = stock.symbol
//                cell.priceLabel.text = stock.price
//                cell.nameLabel.text = stock.name
//                cell.set(dayChange: stock.dayChange)
//            }
//            .addDisposableTo(disposeBag)
        
        viewModel.dataSource?
            .bind(to: tableView.rx.items(cellIdentifier: StockQuoteTableViewCell.reusableIdentifier, cellType: StockQuoteTableViewCell.self))
            { (row, element, cell) in
                cell.symbolLabel.text = element.symbol
                cell.priceLabel.text = element.price
                cell.nameLabel.text = element.name
                cell.set(dayChange: element.dayChange)
            }
            .disposed(by: disposeBag)
        
        // MARK: Selection
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Stock.self))
            .bind { (indexPath, stock) in
                self.tableView.deselectRow(at: indexPath, animated: true)
                print("Selected \(stock) at \(indexPath)")
                let drawer = DrawerViewController()
                drawer.symbol = stock.symbol
//                self.navigationController?.pushViewController(drawer, animated: true)
                drawer.modalPresentationStyle = .overFullScreen
                self.present(drawer, animated: true, completion: nil)
//                if let stocks = Stock.fetchStocks(predicate: nil, context: self.coreDataManager.viewContext) {
//                    //                completion(stocks)
//                    print(stocks)
//                }
        }
        .disposed(by: disposeBag)
    
                
        // MARK: Deletion
        Observable.zip(tableView.rx.itemDeleted, tableView.rx.modelDeleted(Stock.self))
            .bind { (indexPath, stock) in
                self.viewModel.delete(model: stock, index: indexPath)
        }
        .disposed(by: disposeBag)
        
        // MARK: Move
		tableView.rx.itemMoved
        
        // MARK: Add
        viewModel.add(itemTap: addButton.rx.tap.asDriver())

        // MARK: Search
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
//        AlphaVantageAPI().fetchIntraday(symbol: "AAPL", minInterval: 1) { (intradayData, error) in
//            print(intradayData)
//        }
//
//        AlphaVantageAPI().fetchDaily(symbol: "AAPL") { (dailyData, error) in
//            print(dailyData)
//        }
        
//        WorldTradingDataAPI.shared.fetchBatchQuotes(symbols: ["AAPL","GOOG","TSLA","AMZN","FB"]) { [weak self] (batch) in
//            let stocks = batch?.data.map({ (stock) -> StockQuote in
//                StockQuote(symbol: stock["symbol"], open: stock["price_open"], high: stock["day_high"], low: stock["day_low"], price: stock["price"], volume: stock["volume"], close: nil, name: stock["name"], dayChange: stock["day_change"])
//            })
//            self?.stocks = stocks
//        }
        
//        AlphaVantageAPI.shared.fetchBatchQuotes(symbols: ["AAPL","TSLA","FB","MFST","NFLX"]) { [weak self] (batch) in
//            let stocks = batch?.stockBatchQuotes.map({ (stock) -> StockQuote in
//                StockQuote(symbol: stock["1. symbol"], open: stock["2. open"], high: stock["3. high"], low: stock["4. low"], price: stock["5. price"], volume: stock["6. volume"], close: nil, name: nil, dayChange: nil)
////                StockQuote(symbol: stock["1. symbol"], open: stock["2. open"], high: stock["3. high"], low: stock["4. low"], price: stock["5. price"], volume: stock["6. volume"], timestamp: stock["7. timestamp"], currency: stock["8. currency"], close: nil)
//            })
//            self?.stocks = stocks
//        }
    }
    
    // MARK: - Private UI Setup Functions
    // TODO: Fix this
    private func setupDate() {
        setMultiLineTitle()
        let now = Date()
        let df = DateFormatter()
        df.dateFormat = "MMMM d"
        let date = df.string(from: now)
        
        let title = "STOCKS\n" + date
        let attributedString = NSMutableAttributedString(string: title)
        let range = (date as NSString).range(of: date)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: range)
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]
        self.title = title
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
    }
}

//// MARK: - UITableViewDataSource
//
//extension MainStocksViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return stocks?.count ?? 0
//        return viewModel.stocks?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: StockQuoteTableViewCell.reusableIdentifier, for: indexPath) as! StockQuoteTableViewCell
//        if let stocks = viewModel.stocks {
//            let stock = stocks[indexPath.row]
//            cell.symbolLabel.text = stock.symbol
//            cell.nameLabel.text = stock.name ?? stock.high
//            if let dayChange = stock.dayChange {
//                if Double(dayChange)! < 0.00 {
//                    cell.priceLabel.backgroundColor = UIColor.redStock
//                    cell.priceLabel.text = dayChange
//                } else {
//                    cell.priceLabel.text = "+" + dayChange
//                }
//            } else {
//                cell.priceLabel.text = String(format: "$%.2f", Double(stock.price)!*1000.rounded()/1000)
//            }
//        }
//        cell.showsReorderControl = false
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        if let movedObject = viewModel.stocks?[fromIndexPath.row] {
//            viewModel.stocks?.remove(at: fromIndexPath.row)
//            viewModel.stocks?.insert(movedObject, at: fromIndexPath.row)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
//
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//}
//
//// MARK: - UITableViewDelegate
//
//extension MainStocksViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}

extension MainStocksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
}

