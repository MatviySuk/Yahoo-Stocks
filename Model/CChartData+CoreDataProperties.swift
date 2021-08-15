//
//  CChartData+CoreDataProperties.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 26.07.2021.
//
//

import Foundation
import CoreData


extension CChartData {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<CChartData> {
//        return NSFetchRequest<CChartData>(entityName: "CChartData")
//    }
    
    var values: ChartData {
        get {
            ChartData(close: close, volume: volume, low: low, open: `open`, high: high)
        }
        set {
            self.close = newValue.close?.compactMap{$0}
            self.volume = newValue.volume?.compactMap{$0}
            self.low = newValue.low?.compactMap{$0}
            self.`open` = newValue.`open`?.compactMap{$0}
            self.high = newValue.high?.compactMap{$0}
        }
    }

}

extension CChartData : Identifiable {

}
