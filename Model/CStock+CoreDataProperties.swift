//
//  CStock+CoreDataProperties.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 18.07.2021.
//
//

import Foundation
import CoreData


extension CStock {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<CStock> {
//        return NSFetchRequest<CStock>(entityName: "CStock")
//    }

    var instrument: Stock {
        get {
            return Stock(ask: self.ask, bid: self.bid, fiftyTwoWeekHigh: self.fiftyTwoWeekHigh, fiftyTwoWeekLow: self.fiftyTwoWeekLow, longName: self.longName, marketCap: self.marketCap, chart: CChartToChart(chart), symbol: self.symbol)
        }
        set {
            self.ask = newValue.ask ?? 0.0
            self.bid = newValue.bid ?? 0.0
            self.fiftyTwoWeekHigh = newValue.fiftyTwoWeekHigh ?? 0.0
            self.fiftyTwoWeekLow = newValue.fiftyTwoWeekLow ?? 0.0
            self.longName = newValue.longName ?? ""
            self.marketCap = newValue.marketCap ?? 0
            self.symbol = newValue.symbol ?? ""
            self.chart = chartToCChart(newValue.chart)
        }
    }
    
    private func CChartToChart(_ ccharts: [CChartData]?) -> [ChartData]? {
        if ccharts == [] {
            return []
        } else {
            var chart: [ChartData] = []
            ccharts!.forEach { cchart in
                chart.append(cchart.values)
            }
            return chart
        }
    }
    
    private func chartToCChart(_ charts: [ChartData]?) -> [CChartData]? {
        if charts == [] {
            return []
        } else {
            var cchart: [CChartData] = []
            charts!.forEach { chart in
                let newChart = CChartData()
                newChart.values = chart
                cchart.append(newChart)
            }
            return cchart
        }
    }
}

extension CStock : Identifiable {

}
