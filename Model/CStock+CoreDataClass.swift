//
//  CStock+CoreDataClass.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 18.07.2021.
//
//

import Foundation
import CoreData

@objc(CStock)
public class CStock: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    public var ask: Double = 0.0
    public var bid: Double = 0.0
    public var fiftyTwoWeekHigh: Double = 0.0
    public var fiftyTwoWeekLow: Double = 0.0
    public var longName: String? = ""
    public var marketCap: Int64 = 0
    public var symbol: String? = ""
    public var chart: [CChartData]? = []

    
    convenience init(stock: Stock) {
        self.init()
        self.instrument = stock
     }
    
//    convenience public init(insertInto context: NSManagedObjectContext) {
//        let entity = NSEntityDescription.entity(forEntityName: "CStock", in: context)!
//        self.init(entity: entity, insertInto: context)
//    }
    
    public required convenience init?(coder: NSCoder) {
//        self.init(insertInto: StocksViewModel.containers.viewContext)
        self.init()
        ask = coder.decodeDouble(forKey: "ask")
        bid = coder.decodeDouble(forKey: "bid")
        fiftyTwoWeekHigh = coder.decodeDouble(forKey: "fiftyTwoWeekHigh")
        fiftyTwoWeekLow = coder.decodeDouble(forKey: "fiftyTwoWeekLow")
        longName = coder.decodeObject(of: NSString.self, forKey: "longName") as String?
        marketCap = coder.decodeInt64(forKey: "marketCap")
        symbol = coder.decodeObject(of: NSString.self, forKey: "symbol") as String?
        chart = coder.decodeArrayOfObjects(ofClass: CChartData.self, forKey: "chart")
    }

    public func encode(with coder: NSCoder) {
        coder.encode(ask, forKey: "ask")
        coder.encode(bid, forKey: "bid")
        coder.encode(fiftyTwoWeekHigh, forKey: "fiftyTwoWeekHigh")
        coder.encode(fiftyTwoWeekLow, forKey: "fiftyTwoWeekLow")
        coder.encode(longName, forKey: "longName")
        coder.encode(marketCap, forKey: "marketCap")
        coder.encode(symbol, forKey: "symbol")
        coder.encode(chart, forKey: "chart")
    }
}
