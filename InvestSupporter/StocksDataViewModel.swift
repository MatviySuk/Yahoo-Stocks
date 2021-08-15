//
//  StocksDataViewModel.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 07.05.2021.
//

import SwiftUI
import CoreData
import Foundation
import Combine
import Alamofire
import SwiftyJSON

class StocksViewModel: ObservableObject {
    public static let containers = NSPersistentContainer(name: "StocksDataModel")
    let container = StocksViewModel.containers
    private var user: [User] = []
    
    @Published var stocks: [Stock] = []
    @Published var starredStocks: [Stock] = []
    
    init() {
        container.loadPersistentStores { (desciption, error) in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
        fetchStocks()
    }
    
    func fetchStocks() {
        let request = NSFetchRequest<User>(entityName: "User")
        do {
            let users = try container.viewContext.fetch(request)
            if users.isEmpty {
                let newUser = User(context: container.viewContext)
                newUser.choosenStocks = []
                newUser.savedStocks = []
                user.append(newUser)
            } else {
                user = users
            }
            starredStocks.removeAll()
            starredStocks.append(contentsOf: cStockToStock(cStocks: user.first?.savedStocks)!)
            updateStarredStocks(save: false)
        } catch {
            print(error)
        }
    }
    
    // Adding or deleting the stock from starred stocks
    func addStock(_ stock: Stock) {
        if containsStock(starredStocks, stock) {
            deleteStock(stock)
        } else {
            user.first!.savedStocks?.append(stockToCStock(stock))
            saveStocks()
        }
    }
    
    func deleteStock(_ stock: Stock) {
        user.first!.savedStocks?.forEach { cStock in
            if cStock.symbol == stock.symbol {
                if let index = user.first?.savedStocks?.firstIndex(of: cStock) {
                    user.first?.savedStocks?.remove(at: index)
                }
            }
        }
        saveStocks()
    }
    
    func saveStocks() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Saving error: \(error)")
        }
        fetchStocks()
    }
    
    func containsStock(_ array: [Stock], _ stocks: Stock) -> Bool {
        for stock in array {
            if stock.symbol == stocks.symbol {
                return true
            }
        }
        return false
    }
    
    func updateStarredStocks(save: Bool) {
        if !((user.first!.savedStocks?.isEmpty)!) {
            for stock in user.first!.savedStocks! {
                getYahooQuote(symbol: stock.symbol!, period: .oneW) { quoteParent in
                    let quoteResponse: QuoteResponse = quoteParent.quoteResponse
                    if quoteResponse.error == nil && quoteResponse.result?.first! != nil {
                        if self.starredStocks.contains(quoteResponse.result!.first!) {
                            if let index = self.user.first!.savedStocks?.firstIndex(of: self.stockToCStock(quoteResponse.result!.first!)) {
                                self.user.first!.savedStocks?.remove(at: index)
                                self.user.first!.savedStocks?.insert(self.stockToCStock(quoteResponse.result!.first!), at: index)
                            }
                        }
                    }
                }
            }
        }
        if save {
            saveStocks()
        }
    }

    func getYahooQuote(symbol: String, period: TimeRanges, completion: @escaping (QuoteParent) -> Void) {
        let stockURL = "https://query1.finance.yahoo.com/v7/finance/quote?symbols=" + symbol
        let request = AF.request(stockURL, parameters: ["quoteResponse": "result"])
        request.responseData { (response) in
            guard let data = response.value else {return}
            do {
                let json = JSON(data)
                print(json)
                let decoder = JSONDecoder()
                var quoteParent = try decoder.decode(QuoteParent.self, from: data)
                self.getChartQuote(symbol: symbol, period: period) { chartQuote in
                    var data: [ChartData] = []
                    data.append(ChartData(close: [0.0, 0.0], volume: [0.0, 0.0], low: [0.0, 0.0], open: [0.0, 0.0], high: [0.0, 0.0]))
                    quoteParent.quoteResponse.result![0].chart = chartQuote.chart.result?.first?.indicators?.quote ?? data
                    completion(quoteParent)
                    print(quoteParent)
                }
            } catch {
                var errorParent = QuoteParent()
                errorParent.quoteResponse.error = QuoteError(error: error)
                print(error)
                completion(errorParent)
            }
        }
    }
    private func getChartQuote(symbol: String, period: TimeRanges, completion: @escaping (ChartQuote) -> Void) {
        let stockURL = "https://query1.finance.yahoo.com/v8/finance/chart/\(String(symbol))?symbol=\(String(symbol))" +         "&period1=\(String((Int(Date().timeIntervalSince1970) - period.rawValue)))" +
            "&period2=\(String(Int(Date().timeIntervalSince1970)))&interval=\(getInterval(period: period))"
        let request = AF.request(stockURL, parameters: ["chart": "result"])
        request.responseData { (response) in
            guard let data = response.value else {return}
            do {
                let json = JSON(data)
                print(json)
                let decoder = JSONDecoder()
                var chartQuote = try decoder.decode(ChartQuote.self, from: data)
                chartQuote.chart.result?[0].indicators?.cleanNILLValues()
                print(chartQuote)
                completion(chartQuote)
            } catch {
                print(error)
            }
        }
    }
        
    private func stockToCStock(_ stock: Stock) -> CStock {
        let cstock = CStock()
//        let cstock = CStock(insertInto: container.viewContext)
        cstock.instrument = stock
        return cstock
    }
 
    private func cStockToStock(cStocks: [CStock]?) -> [Stock]? {
        if cStocks == nil {
            return []
        } else {
            var stocks: [Stock] = []
            cStocks!.forEach { cStock in
                stocks.append(cStock.instrument)
            }
            return stocks
        }
    }
    
    private func getInterval(period: TimeRanges) -> String {
        switch period {
            case .oneD:
                return "30m"
            case .oneW:
                return "1h"
            case .oneM:
                return "90m"
            case .threeM:
                return "1d"
            case .sixM:
                return "1d"
            case .oneY:
                return "5d"
            case .twoY:
                return "1wk"
            case .fiveY:
                return "1mo"
            case .tenY:
                return "3mo"
            case .all:
                return "3mo"
        }
    }
}

//    private let dataSourceURL: URL
//    private var autosave: AnyCancellable?
//
//     Autosave all changes (autosave)
//    init() {
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let notesPath = documentsPath.appendingPathComponent("stocksData").appendingPathExtension("json")
//        dataSourceURL = notesPath
//
//        let decoder = PropertyListDecoder()
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try Data(contentsOf: dataSourceURL)
//            starredStocks = try! decoder.decode([Stock].self, from: data)
//            autosave = $starredStocks.sink { stocks in
//                let data = try! encoder.encode(stocks)
//                try! data.write(to: self.dataSourceURL)
//            }
//        } catch {
//            let info = try! encoder.encode(starredStocks)
//            try! info.write(to: self.dataSourceURL)
//        }
//    }
